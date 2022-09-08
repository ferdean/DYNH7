function data = jsondecoder(dataID)
% Reads, interprets and decodes a JSON file creating a MATLAB struct in the
% workspace
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

narginchk(1,1)
dataID = string(dataID);

if  all([all(dataID ~= "Derivative_Descriptor"), all(dataID ~= "IIR_Filter_Descriptor"), ...
         all(dataID ~= "PI_Descriptor"), all(dataID ~= "PID_Descriptor"), ...
         all(dataID ~= "State_Space_Descriptor"), all(dataID ~= "Derivative_Filter_Descriptor"),...
         all(dataID ~= "Airgap_Filter_Descriptor"), all(dataID ~= "Current_Filter_Descriptor")])
    
    error('Nonexisting ID for the data. Check >>help jsonencoder for reference.')
end

dataID = [char(dataID), '.json'];

fileID = fopen(dataID);

raw    = fread(fileID, inf);
str    = char(raw');
data   = jsondecode(str);

end