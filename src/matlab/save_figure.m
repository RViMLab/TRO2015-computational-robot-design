function save_figure(handle, filename, mime)
%
% FUNCTION
%   SAVE_FIGURE saves a figures based on a given handle, at different
%   mimetype, or simultaneously a .eps, .pdf, and .png.
%
% USAGE
%   SAVE_FIGURE(HANDLE, FILENAME, MIME).
%
% INPUT
%   HANDLE: The handle of the figure to be saved.
%   FILENAME: The full path to the position of the saved image.
%   MIME: Can be 'jpg', 'fig', 'pdf', 'eps', 'png', 'all'.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   22/07/2010
%

    if nargin < 3
        mime = 'all';
    end
    if nargin < 2
        error('SAVE_FIGURE: At least two input arguments are required.');
    end
    
    directory = get_parent_directory(filename);
    
    if ~exist(directory, 'dir')
        [success message] = mkdir(directory);
        warning('SAVE_FIGURE: Creating the required directory...');
    end

    if strcmp(mime, 'all')
        saveas(handle, filename, 'png');
        saveas(handle, filename, 'fig');
        saveas(handle, filename, 'eps');
        saveas(handle, filename, 'pdf');
    else
        saveas(handle, filename, mime);
    end
    
end

%    Copyright (C) 2010  Christos Bergeles <christosbergeles@gmail.com>
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
