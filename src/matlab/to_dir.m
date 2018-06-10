function directory = to_dir(str)
%
% FUNCTION
%   TO_DIR makes sure that the last character is either '/' or '\'
%   depending on the os.
%
% USAGE
%   DIRECTORY = TO_DIR(STR).
%
% INPUT
%   STR: The directory string to be examined.
%
% OUTPUT
%   DIRECTORY: The final corrected directory path.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   24/02/2010
%

    if nargin ~= 1
        error('TO_DIR: A single argument is required.');
    end

    directory = str;
    
    os = get_operating_system;

    switch os
        case 'linux'
            if ~strcmp(str(end), '/')
                directory = [str '/'];
            end
        case 'mac'
            if ~strcmp(str(end), '/')
                directory = [str '/'];
            end
        case 'windows'
            if ~strcmp(str(end), '\')
                directory = [str '\'];
            end
        otherwise
            error('TO_DIR: Wrong supplied operating system.');
    end

end
            