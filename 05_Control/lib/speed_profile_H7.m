function out = speed_profile_H7(N)
% Computes the speed profile of a 1 degree of freedom case. 
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 15.12.2021
% ═════════════════════════════════════════════════════════════════════════
% INPUT:
% N:        Scalar. Number of time steps considered in the simulation 
% ═════════════════════════════════════════════════════════════════════════
% OUTPUT
% out:      Struct. Data structure encapuslating the following data:
%    x:     Vector. Position in meters.
%    v:     Vector. Velocity in km/h.
%    a:     Vector. Acceleration in G.
%    v:     Vector. Time vector.
% ═════════════════════════════════════════════════════════════════════════


global pod;

d_brake = pod.brakes.d;    


vect0   = zeros(N,1);

x = vect0; % Position vector (m)
v = vect0; % Velocity vector (m/s)
a = vect0; % Acceleration vector (m/s2)
t = vect0; % Time vector (s)


FTraction   = vect0; %Traction force (N)
FBrake      = vect0; % Braking force (N)
FDrag       = vect0; % Drag force (N)

i       = 2;      % Counter %Starting in '2' because we have just defined the initial value i=1
brake   = false;  % Braking phase 1: braking system delay

delay   = 0;      % Detect if we are on phase between brake and throttle
ts_t    = 0;      % pneumatic transient state time

while (1)
     clc;
     fprintf("Iteration %d/%d\n", i, N)
     FDrag(i) = pod.levitation.n * ppval(pod.levitation.drag1.cs,v(i-1));
     
     %LONGITUDINAL FORCE
     if ~ brake
         FTraction(i) = ppval(pod.propulsion.cs,v(i-1));
         FBrake(i)    = 0;
     else
         FTraction(i) = 0;
         FBrake(i)    = pod.brakes.force*pod.brakes.n;
     end

     SumFx = FTraction(i) - FDrag(i) - FBrake(i);
     
     % Kinematic study
     a(i) = SumFx/(pod.mass.mass); % Acceleration
     v(i) = v(i-1) + a(i)*pod.general.dt; % Velocity
     x(i) = x(i-1) + v(i)*pod.general.dt + 0.5*a(i)*pod.general.dt^2; % Position
   

    if x(i) >= pod.general.d_track
        
         x(i) = pod.general.d_track;
         v(i) = 0;
         a(i) = 0;
         FTraction(i) = 0;
         FBrake(i) = 0;
         
         break;
    end

    if v(i) < 0
       
         v(i) = 0;
         a(i) = 0;
         x(i) = x(i-1);
         FTraction(i) = 0;
         FBrake(i) = 0;
         

         break; % Exit the loop
    end

    if x(i) >= d_brake && ~brake % We'll try to adjust exactly to the braking distance:
    
         if abs(a(i)) > 1e-10 % If we are accelerating o decelerating
            ti = ( -v(i) + sqrt(v(i)^2 - 2*a(i)*(x(i) - d_brake)) ) / a(i);
            v(i) = v(i-1) + a(i)*ti;
            x(i) = x(i-1) + v(i)*ti + 0.5*a(i)*ti^2;
            
         else % Constant velocity
             a(i) = 0;
             v(i) = v(i-1);
             t(i) = t(i-1) + (d_brake-x(i))/v(i);
             x(i) = v(i)*(t(i)-t(i-1));
            
         end
         
         x(i) = d_brake;
         brake = true;
         
    end


i = i + 1;
end

      t(i) = t(i-1)+pod.general.dt;

      if i>1.5*N
           warning('\n ALERT! ITERATIONS EXCEEDED 1.5 x nsteps!\n')
      end

out.x   = x;
out.v   = 3.6*v;
out.t   = t;
out.a   = 1/9.81 * a;

maxv = max(out.v);     %maximum velocity
maxa = max(out.a);     %maximum acceleration
mina = min(out.a);     %maximum decceleration

fprintf('\n Your maximum velocity is %2.3f km/h \n Your maximum acceleration is %1.3f Gs \n Your maximum decceleration is %1.3f g',maxv,maxa,mina)

%%%%%%%%%%%%%%%%
% yyaxis left
% hplot1 = plot(out.x,out.v,'Color',[170,78,47]/255,'LineWidth',2,'DisplayName','Velocity[km/h]');
% xlabel('Distance [m]');
% ylabel('Velocity [km/h]','Color',[170,78,47]/255)
% ax = gca;
% ax.YColor = [170,78,47]/255;
% 
% hold on
% yyaxis right
% hplot2 = plot(out.x,out.a,'Color',[0,0,0]/255,'LineWidth',2,'DisplayName','Acceleration[g]');
% ylabel('Acceleration [g]','Color',[0,0,0]/255);
% ax = gca;
% ax.YColor = [0,0,0]/255;
% 
% hold on
% yyaxis right
% plot([20,20],[-1,0],'r--')
% 
% hold on
% yyaxis left
% plot([20,20],[0,25],'r--')
% 
% xlim([0 22])
% grid on
% grid minor
% title('Speed Profile')



end

