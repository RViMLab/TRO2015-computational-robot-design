function h = plot_point_cloud(X, lineStyle)
%
% FUNCTION
%   PLOT_POINT_CLOUD takes homogeneous coordinates X and plots them.
%
% USAGE
%   H = PLOT_POINT_CLOUD(X, LINESTYLE).
%
% INPUT
%   X: The {3, 4}xN homogeneous coordinates to be plotted.
%   LINESTYLE: A line style (whatever plot3 supports).
%
% OUTPUT
%   H: The handle to the created figure;
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   10/08/2010
%

    if nargin < 2
      % check the options
      lineStyle = 'r';
    end
    if nargin < 1
        error('PLOT_POINT_CLOUD: At least one argument is required.');
    end

    if numel(X) == 0
      return;
    end
    
    % Check if vertex colours are passed
    if size(lineStyle) == size(X(1:3, :))
      
      if (max(lineStyle(1, :)) > 1)
        lineStyle = lineStyle/255;
      end
      h = scatter3(X(1, :), X(2, :), X(3, :), 13, lineStyle', 'filled');
      
    else
      h = plot3(X(1,:), X(2,:), X(3,:), lineStyle);
    end
    
end