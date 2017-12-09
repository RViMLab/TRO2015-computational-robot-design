function res = CTRInverseKinematics(y, ctr_, HG, target, vector, anatomy, torsional_compliance)

  if torsional_compliance
    [ctr_ alpha_tip] = CTRUnpackageVariablesTorsional(y, ctr_);
    [end_effector, curve, ctr, ~, ~, ~, ~] = ...
      CTRKinematicsTorsional(ctr_, HG, alpha_tip);
  else
    ctr_ = CTRUnpackageVariables(y, ctr_);
    [end_effector, curve, ctr] = CTRKinematics(ctr_, HG);
  end
  
  pos_tip = pos(end_effector);
  dist = sqrt(sum((pos_tip - target').^2));
  
  % Penalize end-effector position heavily
  res_tip = 1*fweight(dist, 1.5e-3); %1e+7*dist; % ; %1e+5*dist;
  
  res_angle = 0;
  if ~isempty(vector)
    % Penalize angle difference heavily
    % res_angle = 1e+5*norm(end_effector(1:3, 3) - vector); % 1e+5*abs(acos(dot(end_effector(1:3, 3), vector)));
    % Andrew uses fweight within 0.5 degree
    res_angle = fweight( abs( rad2deg(acos(dot(end_effector(1:3, 3), vector)))), rad2deg(0.5) ); 
  end

  % The overlap with the anatomy should be less than 1%
  res_anat = 0;
  if ~isempty(anatomy)
  
    X = CTRDetectCollisions(ctr, anatomy);
    
    if ~isempty(anatomy.spline) % if spline exists, then consider the angles

      
      qradii = 3e-3;
      for ind = 2:size(X, 2)

        qpoint = X(1:3, ind);
        [temp_idx, ~] =  anatomy.kdtree.ball(qpoint', qradii);
        % res_anat = res_anat + length(temp_idx);

        % Find the angles
        if ~isempty(temp_idx)

          curve_tangent = X(1:3, ind) - X(1:3, ind - 1);
          curve_tangent = curve_tangent/norm(curve_tangent);
          ctr_angle = rad2deg(pi/2 - acos(anatomy.normals(:, temp_idx)'*curve_tangent));

          res_anat = 1000*abs(max((abs(ctr_angle))) - 25);

        end
      end

    else
      
      if torsional_compliance
        res_anat = 1e+3*size(X, 2);
      else
        res_anat = CTRDistanceFromAnatomy(ctr, anatomy) + 1e+3*size(X, 2);
      end
    end
    
  end
  
%   hold on;
%   plot_point_cloud(curve, 'r');
%   plot_point_cloud(X, '+b');
%   hold off;
%   pause(0.05);
  
  % Find the points on the curve that intersect with the anatomy
  res = (res_tip + res_angle + res_anat); % + 10*sum([ctr_(1:end-1).phi]);

end
