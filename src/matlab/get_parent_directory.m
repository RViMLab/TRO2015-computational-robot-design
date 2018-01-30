function parent_directory = get_parent_directory(directory)
%
% FUNCTION
%   GET_PARENT_DIRECTORY gets the parent directory from either the current
%   directory, or a given directory.
%
% USAGE
%   PARENT_DIRECTORY = GET_PARENT_DIRECTORY(DIRECTORY).
%
% INPUT
%   DIRECTORY: The child directory.
%
% OUTPUT
%   PARRENT_DIRECTORY: The parent directory.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   09/07/2010
%

    if nargin < 1
        directory = to_dir(cd());
    end
   
    os = get_operating_system();
    % Use the approprilate splitting symbol and split the directory
    switch os
        case 'mac'
            split_symbol = '/';
        case 'linux'
            split_symbol = '/';
        case 'windows'
            split_symbol = '\';
        otherwise
            error('GET_PARENT_DIRECTORY: Operating system not supported.');
    end
    
    R = regexp(directory, split_symbol, 'split');
    
    parent_directory = [];
    % Now concatenate the given string except the last
    if strcmp(os, 'linux') || strcmp(os, 'mac')
        start = 2; % First symbol in directory is the '/' which leads to an empty first string
    else
        start = 1;
    end
    if strcmp(R{end}, '')
        stop = length(R) - 2; % The last string is empty because of the to_dir() function
    else
        stop = length(R) - 1; % If a filename is passed
    end
    
    for i = start:stop 
        if strcmp(os, 'windows') && i == start
            parent_directory = strcat(parent_directory, R{i});
        else
            parent_directory = strcat(parent_directory, split_symbol, R{i});
        end
    end
    parent_directory = to_dir(parent_directory);
   
end