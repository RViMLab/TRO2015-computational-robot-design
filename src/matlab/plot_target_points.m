function h = plot_target_points(points, linestyle)
%
% FUNCTION
%   PLOT_TARGET_POINTS plots the targets points for the concentric tube
%   robot optimization.
%
% USAGE
%   H = PLOT_TARGET_POINTS(POINTS).
%
% INPUT
%   POINTS: The Nx3 array containing the points of interest.
%   LINESTYLE: Style to be passed in the plot function.
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

  if nargin < 2
    linestyle = '.r';
  end
  if nargin < 1
      error('PLOT_TARGET_POINTS: At least one argument is required.');
  end

  hold on
  h = plot_point_cloud(points', linestyle);
  set(h, 'MarkerSize', 20);
  hold off
end