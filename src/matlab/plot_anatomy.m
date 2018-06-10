function [h data] = plot_anatomy(filename)
%
% FUNCTION
%   PLOT_ANATOMY plots the anatomy after reading a given file. If the file
%   is not given, the user is prompted to select it.
%
% USAGE
%   [H DATA] = PLOT_ANATOMY(FILENAME).
%
% INPUT
%   FILENAME: Full path to the file of interest.
%
% OUTPUT
%   H: Handle to the generated plot.
%   DATA: The data read from the file.
%
% AUTHOR
%   Christos Bergeles
%   Andrew Gosline
%
% DATE
%   2012.05.25
%

  if nargin < 1
      [filename pathname] = uigetfile( ...
       {'*.mat','MAT-files (*.mat)'}, ...
        'Pick the anatomical model:', ...
        'MultiSelect', 'off');
      filename = strcat(to_dir(pathname), filename);
  end

  anatomy = load_anatomy(filename);
  
  trisurf(anatomy.tri, anatomy.pts(:, 1), anatomy.pts(:, 2), anatomy.pts(:,3), ...
         'FaceVertexCData', [0.2 0 1],...
         'EdgeColor','none', ...
         'AmbientStrength', 0.5,...
         'DiffuseStrength', 1);
  
  camlight right; 
  camlight left;
  lighting phong;
  alpha(0.2);
  
  axis equal
  box on

end