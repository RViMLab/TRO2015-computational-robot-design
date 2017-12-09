function [end_effector curve ctr res] = CTRSolveInverseKinematics(ctr_, HG, target, min_method, vector, anatomy, torsional_compliance)
%
% FUNCTION
%   CTRSolveInverseKinematics() solves the inverse kinematics via
%   optimization, respecting anatomical contrains, and aiming to approach
%   the target vector.
%
% USAGE
%
% INPUT
%   CTR_: The (simple) concentric tube robot structure.
%   HG: The base homogeneous transform.
%   TARGET: The desired end-effector position.
%   MIN_METHOD: The minimization method.
%   VECTOR: The desired end-effector orientation.
%   ANATOMY: The binary anatomy map.
%   TORSIONAL_COMPLIANCE: Defaults to 'false'.
%   
% OUTPUT
%   END_EFFECTOR: The homogeneous transformation of the end effector.
%   CURVE: The calculated curve.
%   CTR: The updated full concentric tube robot.
%   RES: The residual.
%
% AUTHOR
%   Christos Bergeles
%   Andrew Gosline
%
% DATE
%   2012.10.31
%

  if nargin < 7
    torsional_compliance = false;
  end

  if nargin < 6
    anatomy = [];
  end
  
  if nargin < 5
    vector = [];
  end
  
  if nargin < 4
    min_method = 'fminsearchbnd';
  end
    
  if nargin < 3
    error('CTRSolveInverseKinematics: At least three input arguments are required.');
  end

  [y_ y_min y_max] = CTRPackageVariables(ctr_);
  
  if strcmp(min_method, 'patternsearch')
    opts = psoptimset('TolMesh', 1e-30, 'TolX', 1e-40, 'MaxIter', 1e+6, 'TolFun', 1e-35, 'Cache', 'on');
    [y, res] = patternsearch(@(y_) CTRInverseKinematics(y_, ctr_, HG, target, vector, anatomy, torsional_compliance), ...
                             y_, ...
                             [], [], [], [], ...
                             y_min, ...
                             y_max, ...
                             opts);
  elseif strcmp(min_method, 'fminsearchbnd')
    opts = optimset('TolX', 1e-10, 'TolFun', 1e-10, 'DiffMinChange', 1e-7, 'MaxFunEvals', 0.5e+3, 'MaxIter', 0.5e+3);
    if torsional_compliance
      i_end = 2;
    else
      i_end = 3;
    end
    for i = 1:i_end
      opts = optimset('TolX', 1e-10, 'TolFun', 1e-10, 'DiffMinChange', 1e-7, 'MaxFunEvals', 0.5e+3, 'MaxIter', 0.5e+3);
      [y_, res] = fminsearchbnd(@(y_) CTRInverseKinematics(y_, ctr_, HG, target, vector, anatomy, torsional_compliance), ...
                               y_, ...
                               y_min, ...
                               y_max, ...
                               opts);
%       opts = psoptimset('TolMesh', 1e-30, 'TolX', 1e-40, 'MaxIter', 1e+6, 'TolFun', 1e-35, 'Cache', 'on');
%       [y_, res] = patternsearch(@(y_) CTRInverseKinematics(y_, ctr_, HG, target, vector, anatomy, torsional_compliance), ...
%                                y_, ...
%                                [], [], [], [], ...
%                                y_min, ...
%                                y_max, ...
%                                opts);
    end
    y = y_;
  end
  
  % Create the full robot
  if torsional_compliance
    [ctr_ alpha_tip] = CTRUnpackageVariablesTorsional(y, ctr_);
    [end_effector, curve, ctr] = CTRKinematicsTorsional(ctr_, HG, alpha_tip);
  else
    ctr_ = CTRUnpackageVariables(y, ctr_);
    [end_effector, curve, ctr] = CTRKinematics(ctr_, HG);
  end
  
end
