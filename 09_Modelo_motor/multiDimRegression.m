function reg = multiDimRegression(Data,R,PW,varargin)

    % Align Data
    if size(Data,2)>size(Data,1)
        Data=Data';
    end
    
    % Arrange Input Arguments
    PV = repmat(PW,[1,size(Data,2)]);
    LegendSwitch='legendoff';
    FigureSwitch='figureoff';
    NormalizationSwitch='1-to-1 (Default)';
    if nargin > 3
        for ii=1:length(varargin)
            if strcmp(varargin{ii},'figure') == 1
                FigureSwitch='figureon';
            end
            if strcmp(varargin{ii},'range') == 1
                NormalizationSwitch='Range';
            end
            if isnumeric(varargin{ii}) == 1
                PV=varargin{ii};
            end
        end
    end
    
    % Function Parameters
    NData = size(Data,1);
    NVars = size(Data,2);
    RowMultiB = '1';
    RowMultiC = '1';
    Lim = max(PV);
    
    % Initialize
    A=zeros(Lim^NVars,NVars);
    % Create Colums Corresponding to Mathematical Base
    for ii=1:NVars
        A(:,ii)=mod(floor((1:Lim^NVars)/Lim^(ii-1)),Lim);
    end
    % Flip - Reduce - Augment
    A=fliplr(A); A=A(sum(A,2)<=Lim,:); Ab=diag(repmat(Lim,[1,NVars])); A=[A;Ab];
    % Degree Conditionals
    for ii=1:NVars
        A=A(A(:,ii)<=PV(ii),:);
    end
    % Build Framework
    NLegend = size(A,1);
    Legend=cell(NLegend,1);
    for ii=1:NVars
        RowMultiC=strcat(RowMultiC,['.*C(:,',num2str(ii),')']);
    end
    % Create a Legend for Coefficient Correspondence
    for ii=1:NLegend
        currentTerm=find(A(ii,:));
        currentLegend='';
        for jj=1:length(currentTerm)
            if jj==1
                currentLegend=[currentLegend,'x',num2str(currentTerm(jj))];
                if A(ii,currentTerm(jj)) > 1
                    currentLegend=[currentLegend,'.^',num2str(A(ii,currentTerm(jj)))];
                end
            else                  
                currentLegend=[currentLegend,'.*x',num2str(currentTerm(jj))];
                if A(ii,currentTerm(jj)) > 1
                    currentLegend=[currentLegend,'.^',num2str(A(ii,currentTerm(jj)))];
                end
            end
        end
        Legend{ii,1}=currentLegend;
    end
    % Allocate
    Scores = zeros(NData,NLegend);
    
    % Compose
    for ii=1:NData
        current=repmat(Data(ii,:),[NLegend,1]);
        C=current.^A; %#ok<NASGU>
        Scores(ii,:) = eval(RowMultiC);
    end
	% Use  QR to avoid explicit inversion and check rank. 
    [QQ,RR,perm] = qr(Scores,0);
    p = sum(abs(diag(RR)) > size(Scores,2)*eps(RR(1)));
  
    if p < size(Scores,2)
        warning('Rank Deficiency within Polynomial Terms!');
        RR = RR(1:p,1:p);
        QQ = QQ(:,1:p);
        perm = perm(1:p);
    end
    
	% Ordinary Least Squares Regression
    b = zeros(size(Scores,2),1);
	b(perm) = RR \ (QQ'*R);
	yhat = Scores*b;                     
    r = R-yhat;   
    
    % Polynomial Expression
    L=char(Legend);
    L(L(:,1)==' ')='1';
    B=num2str(b);
    Poly=[repmat(char('+'),[size(B,1) 1]) B repmat(char('.*'),[size(B,1) 1]) L]';
    Poly=reshape(Poly,[1 size(Poly,1)*size(Poly,2)]);
    
    variablesexp='@(';
    for ii=1:size(A,2)
        if ii==1
            variablesexp=[variablesexp,'x',num2str(ii)];
        else
            variablesexp=[variablesexp,',x',num2str(ii)];
        end
    end
    variablesexp=[variablesexp,') '];
    
    eval(['PolyExp = ',variablesexp,Poly, ';']);
	
    % Goodness of Fit
    r2 = 1 - (norm(r)).^2/norm(R-mean(R))^2;
    if strcmp(NormalizationSwitch,'Range')==1
        mae = mean(abs(r./abs(max(R)-min(R))));
        maestd = std(abs(r./abs(max(R)-min(R)))); 
    else
        mae = mean(abs(r./R));
        maestd = std(abs(r./R));
    end
    
	% Leave One Out Cross Validation
    dH=sum(QQ.^2,2);
    rCV=r./(1-dH);
    % LOOCV Goodness of Fit
    CVr2 = 1 - (norm(rCV)).^2/norm(R-mean(R))^2; 
    if strcmp(NormalizationSwitch,'Range')==1
        CVmae = mean(abs(rCV./abs(max(R)-min(R))));
        CVmaestd = std(abs(rCV./abs(max(R)-min(R)))); 
    else
        CVmae = mean(abs(rCV./R));
        CVmaestd = std(abs(rCV./R));
    end
    
    % Construct Output
    reg = struct('FitParameters','-----------------','PowerMatrix',A,'Scores',Scores, ...
        'PolynomialExpression',PolyExp,'Coefficients',b, 'Legend', L, 'yhat', yhat, 'Residuals', r, ...
        'GoodnessOfFit','-----------------', 'RSquare', r2, 'MAE', mae, 'MAESTD', maestd, ...
        'Normalization',NormalizationSwitch,'LOOCVGoodnessOfFit','-----------------', 'CVRSquare', ...
        CVr2, 'CVMAE', CVmae, 'CVMAESTD', CVmaestd,'CVNormalization',NormalizationSwitch);
    
    % Optional Figure
    if strcmp(FigureSwitch,'figureon')==1
        figure1 = figure;
        axes1 = axes('Parent',figure1,'FontSize',16,'FontName','Times New Roman');
        line(yhat,R,'Parent',axes1,'Tag','Data','MarkerFaceColor',[1 0 0],...
            'MarkerEdgeColor',[1 0 0],...
            'Marker','o',...
            'LineStyle','none',...
            'Color',[0 0 1]);
        xlabel('yhat','FontSize',20,'FontName','Times New Roman');
        ylabel('y','FontSize',20,'FontName','Times New Roman');     
        title('Goodness of Fit Scatter Plot','FontSize',20,'FontName','Times New Roman');
        line([min([yhat,R]),max([yhat,R])],[min([yhat,R]),max([yhat,R])],'Parent',axes1,'Tag','Reference Ends','LineWidth',3,'color','black');
        axis tight
        axis square
        grid on
    end
end
    
