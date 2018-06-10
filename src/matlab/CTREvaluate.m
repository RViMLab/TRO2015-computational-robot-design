function [h res ctr] = CTREvaluate(ctr_, HG, anatomy, targets, vector, method, torsional_compliance)
%
% FUNCTION
%   CTREVALUATE draws the concentric tube robot CTR after calculating the
%   inverse kinematics to reach TARGETS respecting the ANATOMY.
%
% USAGE
%   CTREVALUATE(CTR_, HG, ANATOMY, TARGETS, VECTOR, METHOD, TORSIONAL_COMPLIANCE).
%
% INPUT
%   CTR_: The (simple) concentric tube robot structure.
%   HG: The homogeneous transformation at the entry point.
%   ANATOMY: The structure containing the information of the anatomy.
%   TARGETS: The targets that need to be reached.
%   VECTOR: 4x1 vector containing the prefered orientation of the end
%   effector.
%   METHOD: Minimization method.
%   TORSIONAL_COMPLIANCE: Defaults to 'false'.
%
% OUTPUT
%   H: Handle to a figure with all the optimal configurations.
%   RES: The error.
%   CTR: The solution to the inverse kinematics for the final target point.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   2012.10.31
%

  global debug;

  if nargin < 6
    torsional_compliance = false;
  end
  if nargin < 5
    error('CTREvaluate: Five input arguments are required.');
  end
  
  h = figure(1);
  clf
  
  res = zeros(size(targets, 1), 1);
  
  if debug
    hold on
    plot_anatomy(anatomy.filename);
    plot_target_points(targets);
    hold off
    % axis([.04 .11 .06 .12 .08 .15]); 
  end
  
  ctr = cell(size(targets, 1), 1);
  for i = 1:size(targets, 1)
    
    target = targets(i, :);
    
    if ~torsional_compliance
      [end_effector, ~, ctr{i}, res(i)] = CTRSolveInverseKinematics(ctr_, HG, target, method, vector, anatomy, torsional_compliance);
    else
      [end_effector, ~, ctr{i}, res(i)] = CTRSolveInverseKinematics(ctr_, HG, target, method, vector, anatomy, torsional_compliance);
    end
    
    % Transfer the reached inverse kinematics parameters to the next ctr_
    % structure
    if ~torsional_compliance
      ctr_ = CTRCreateSimpleCTRFromFullCTR(ctr{i});
    end
    
    if debug
      
      if ~isempty(anatomy)

        X = CTRDetectCollisions(ctr{i}, anatomy);

        if ~isempty(anatomy.spline) % if spline exists, then consider the angles
          
          qradii = 1.1e-3;
          idxs = [];
          for ind = 1:size(X, 2)

            qpoint = X(1:3, ind);
            [temp_idx, ~] =  anatomy.kdtree.ball(qpoint', qradii);
            if ~isempty(temp_idx)
              idxs = [ind idxs];
            end
          end

          X = X(:, idxs);

        end

      end

%       hold on;
%       fig = plot_point_cloud(X, '*k');
%       set(fig, 'MarkerSize', 25);
%       if ~isempty(vector)
%         quiver3(target(1), target(2), target(3), ...
%                 vector(1), vector(2), vector(3), 0.5e-2);
%         quiver3(end_effector(1, 4), end_effector(2, 4), end_effector(3, 4), ...
%                 end_effector(1, 3), end_effector(2, 3), end_effector(3, 3), 0.5e-2);
%       end
%       CTRPlot(ctr{i});
%       plot_point_cloud(pos(end_effector), 'r.');
%       hold off;
%       view(4, 4);
%       % axis([.04 .11 .06 .12 .08 .15]); 
%       title(num2str(sum(res)));
%       % grid on;
%       % box on;
%       pause(0.1);
  
    end
    
    % fprintf('Error in tip position: %f mm\n', norm(target' - pos(end_effector))*1e+3);
    % fprintf('Error in angle: %f degrees\n\n', rad2deg(acos(dot(vector, end_effector(1:3, 3)))));
    
%     if res(i) > 1e+4
%       
%       res(i:end) = res(i);
%       break
%       
%     end
%     
  end
  
end