function varargout = jsonencoder(varargin)
  %
  % Encode data to JSON-formatted file
  %
  % USAGE::
  %
  %   bids.util.jsonencode(filename, json, opts)
  %
  % :param filename: JSON filename
  % :type filename: string
  % :param json: JSON structure
  % :type json: structure
  %
  %
  % USAGE::
  %
  %   S = bids.util.jsonencode(json, opts)
  %
  % :param json: JSON structure
  % :type json: structure
  %
  % :returns: - :S: (string) serialized JSON structure
  %
  %
  % :param opts: optional parameters
  % :type opts: structure
  %
  %   - ``prettyPrint``: indent output [Default: ``true``]
  %   - ``ReplacementStyle``: string to control how non-alphanumeric
  %                       characters are replaced; [Default: ``'underscore'``]
  %   - ``ConvertInfAndNaN``: encode ``NaN``, ``Inf`` and ``-Inf`` as ``"null"``;
  %                       [Default: ``true``]
  %
  % (C) Copyright 2018 Guillaume Flandin, Wellcome Centre for Human Neuroimaging
  %
  % (C) Copyright 2018 BIDS-MATLAB developers

  persistent has_jsondecode
  if isempty(has_jsondecode)
    has_jsondecode = ...
        exist('jsondecode', 'builtin') == 5 || ... % MATLAB >= R2016b
        ismember(exist('jsondecode', 'file'), [2 3]); % jsonstuff / Matlab-compatible implementation
  end

  if has_jsondecode
    value = jsondecode(fileread(file));

    % JSONio
  elseif exist('jsonread', 'file') == 3
    value = jsonread(file, varargin{:});

    % SPM12
  elseif exist('spm_jsonread', 'file') == 3
    value = spm_jsonread(file, varargin{:});

  else
    url = 'https://github.com/gllmflndn/JSONio';
    error('JSON library required: install JSONio from: %s', url);
  end

end