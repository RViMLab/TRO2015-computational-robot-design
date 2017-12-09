function h = CTRPlot(ctr)
%
% FUNCTION
%   CTRPlot plots a concentric tube robot based on the given parameters
%
% USAGE
%   H = CTRPlot(CTR).
%
% INPUT
%   CTR: The structure that contains the concentric tube robot parameters.
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
      error('CTRPlot: At least one argument is required.');
  end
  hold on
  max_diam = max([ctr(:).diameter]);
  min_diam = min([ctr(:).diameter]);
  h = [];
  for i = 1:length(ctr)

    if ~isempty(ctr(i).curve)
    
      [x, y, z] = tubeplot(ctr(i).curve(1, :), ctr(i).curve(2, :), ctr(i).curve(3, :), 0.5*ctr(i).diameter);
      
      h = [h plot_point_cloud(ctr(i).curve, 'r')];
      if (max_diam - min_diam) == 0
        scl = 1;
      else
        scl = (ctr(i).diameter - min_diam)/(max_diam - min_diam);
      end
        
      if ctr(i).u_temp(1) < 1e-7 || ctr(i).k_temp(1) <= 1e-3
        if length(ctr(i).u) == 1
          col = [1 0 0];
        else
          col = [0 1 0];
        end
      else
        if length(ctr(i).u) == 1
          col = 0.5*scl*[1 1 1];
        else
          col = 0.5*scl*[1 1 0];
        end
      end
      
      % set(h(end), 'Color', col);
      % set(h(end), 'LineWidth', 1e+3*ctr(i).diameter);
      
      h = [h mesh(x, y, z, 'FaceColor', col, 'EdgeColor', col)];
      
        
    end

  end
  hold off

end