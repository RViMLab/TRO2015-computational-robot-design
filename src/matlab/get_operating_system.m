function os = get_operating_system()
%
% FUNCTION
%   GET_OPERATING_SYSTEM checks the folder structure and returns 'linux',
%   'mac', 'windows' as the OS.
%
% USAGE
%   OS = GET_OPERATING_SYSTEM.
%
% INPUT
%
% OUTPUT
%   OS: Can be 'linux', 'mac', 'windows'.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   24/02/2010
%

    directory = pwd;
    if strcmp(directory(1), '/')
        if ~isempty(strfind(directory, '/Users')) || ~isempty(strfind(directory, '/Volumes'))
            os = 'mac';
        else
            os = 'linux';
        end
    else
        os = 'windows';
    end

end
        

