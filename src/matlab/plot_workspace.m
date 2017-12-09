function h = plot_workspace(base)
%
% FUNCTION
%   PLOT_WORKSPACE plots a box wherein the base of the continuum robot can
%   be located.
%
% USAGE
%   H = PLOT_WORKSPACE(BASE).
%
% INPUT
%    BASE: Structure containing the Nx3 array containing the points 
%    of interest and patch information.
%
% OUTPUT
%   H: The handle to the created figure.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   2012.05.24
%

  if nargin < 1
      error('PLOT_WORKSPACE: At least one argument is required.');
  end

  h = gcf;
  
  mn_x = min(base.workspace(:, 1));
  mx_x = max(base.workspace(:, 1));
  mn_y = min(base.workspace(:, 2));
  mx_y = max(base.workspace(:, 2));
  mn_z = min(base.workspace(:, 3));
  mx_z = max(base.workspace(:, 3));
  
  hold on
  plot3([mn_x mx_x mx_x mn_x mn_x], [mn_y mn_y mx_y mx_y mn_y], [mn_z mn_z mn_z mn_z mn_z], 'r'); 
  plot3([mn_x mx_x mx_x mn_x mn_x], [mn_y mn_y mx_y mx_y mn_y], [mx_z mx_z mx_z mx_z mx_z], 'r'); 
  
  plot3([mn_x mn_x mn_x mn_x mn_x], [mn_y mn_y mx_y mx_y mn_y], [mn_z mx_z mx_z mn_z mn_z], 'r'); 
  plot3([mx_x mx_x mx_x mx_x mx_x], [mn_y mn_y mx_y mx_y mn_y], [mn_z mx_z mx_z mn_z mn_z], 'r'); 
  
  plot3([mn_x mx_x mx_x mn_x mn_x], [mn_y mn_y mn_y mn_y mn_y], [mn_z mn_z mx_z mx_z mn_z], 'r'); 
  plot3([mn_x mx_x mx_x mn_x mn_x], [mx_y mx_y mx_y mx_y mx_y], [mn_z mn_z mx_z mx_z mn_z], 'r'); 
  hold off
  
end