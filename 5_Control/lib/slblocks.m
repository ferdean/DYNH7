function blkStruct = slblocks
% This function specifies that the library 'mylib'
% should appear in the Library Browser with the 
% name 'My Library'
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 27.12.2021
% ════════════════════════════════════════════════════════════════════════


    Browser.Library = 'libH7';
    % 'mylib' is the name of the library

    Browser.Name = '00. H7 Pod models';
    % 'My Library' is the library name that appears
    % in the Library Browser

    blkStruct.Browser = Browser;