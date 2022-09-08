function data = jsonencoder(data, dataID)
% Encodes a JSON file and saves it to the local machine from a MATLAB
% struct
% ═════════════════════════════════════════════════════════════════════════
% Created by:       Ferran de Andres (04.2022)
% Last updated by:  Ferran de Andres (04.2022)
% ═════════════════════════════════════════════════════════════════════════
% INPUT:
% dataID:        {String} Descritor ID. Should be:
%                   * "Derivative_Descriptor"
%                   * "IIR_ilter_Descriptor"
%                   * "PI_Descriptor"
%                   * "PID_Descriptor"
%                   * "State_Space_Descriptor"
% ═════════════════════════════════════════════════════════════════════════
% OUTPUT
% data:          {Struct} Decoded data
% ═════════════════════════════════════════════════════════════════════════

narginchk(2,2)
dataID = string(dataID);

if  all([all(dataID ~= "Derivative_Descriptor"), all(dataID ~= "IIR_Filter_Descriptor"), ...
         all(dataID ~= "PI_Descriptor"), all(dataID ~= "PID_Descriptor"), ...
         all(dataID ~= "State_Space_Descriptor"), all(dataID ~= "Derivative_Filter_Descriptor"),...
         all(dataID ~= "Airgap_Filter_Descriptor"), all(dataID ~= "Current_Filter_Descriptor")])
    
    error('Nonexisting ID for the data. Check >>help jsonencoder for reference.')
end

dataID = ['files/', char(dataID), '.json'];
data   = jsonencode(data, 'PrettyPrint', true);

fileID = fopen(dataID, 'w');

if fileID == -1
    error('JSON file cannot be created. Try changing the file ID (name or location)'); 
end

fprintf(fileID, data);
fclose(fileID);

end