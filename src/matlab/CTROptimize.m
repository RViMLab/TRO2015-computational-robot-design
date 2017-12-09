function [ctr_ err] = CTROptimize(ctr_, HG, anatomy, targets, vector, base, mopts, torsional_compliance)
%
% FUNCTION
%   CTROPTIMIZE calculates the curvatures and lengths for a given
%   concentric tube robot configuration in order to reach TARGETS based on
%   ANATOMY.
%
% USAGE
%   [CTR ERR] = CTROPTIMIZE(CTR_, HG, ANATOMY, TARGETS, VECTOR, BASE, MOPTS).
%
% INPUT
%   CTR_: A structure containing the parameters of the concentric tube
%   robot.
%   HG: The initial base position.
%   ANATOMY: The file containing the anatomy information.
%   TARGETS: Nx3 points containing the target information.
%   VECTOR: 4x1 vector containing the prefered orientation of the end
%   effector.
%   BASE: The area in which the 'base' of the concentric tube robot can be
%   located.
%   MOPTS: A cell array containing what we should minimize for.
%   TORSIONAL_COMPLIANCE: Defaults to 'false'.
%
% OUTPUT
%   CTR_: The updated simple concentric tube robot structure.
%   ERR: The Nx3 error corresponding to each target point.
%
% AUTHOR
%   Christos Bergeles
%   Andrew Gosline
%
% DATE
%   2012.06.19
%

  global iter;
  global workspace;
  iter = 1;
  workspace = base;

  if nargin < 8
    torsional_compliance = false;
  end
  
  if nargin < 7
    mopts = {'lengths', 'curvatures', 'base'};
  end
  if nargin < 6
    error('CTROptimize: At least six input arguments are required.');
  end
  
  output_directory = CTRPrepOutputDirectory();
  
  anatomy = load_anatomy(anatomy.filename);
  
  % Erode the anatomy image by the size of the largest tube
  [~, ~, ctr] = CTRKinematics(ctr_, HG); % needed for erode anatomy
  [anatomy.binary anatomy.bwdist] = erode_anatomy(anatomy.binary, [ctr(:).diameter]);
  
  % Create the minimization vector
  x_ = CTRCreateMinimizationVectorFromCTR(ctr_, pos(HG), mopts.variables);
  
  % Base bounds
  bnds = CTRCreateMinimizationBounds(ctr_, base.workspace, mopts.variables);
  
  fprintf('CTROptimize: Optimization started.\n');
  tic;
  
  if strcmp(mopts.method, 'patternsearch')
    opts = psoptimset();
    [x err] = patternsearch(@(x_) target_res(x_, ctr_, HG, targets, vector, anatomy, mopts, output_directory, torsional_compliance), ...
                            x_, ...
                            [], [], [], [], ...
                            bnds(1, :), ...
                            bnds(2, :), ...
                            opts);
  elseif strcmp(mopts.method, 'fminsearchbnd')
    opts = optimset(); % 'DiffMinChange', 1e-6);
    % Target_res is Equation (20) in paper
    [x err] = fminsearchbnd(@(x) target_res(x, ctr_, HG, targets, vector, anatomy, mopts, output_directory, torsional_compliance), ...
                            x_, ...
                            bnds(1, :), ...
                            bnds(2, :), ...
                            opts);
  else
    error('CTROptimize: Optimization method not supported.');
  end
  
  [ctr_, ~] = CTRCreateCTRFromMinimizationVector(x, ctr_, mopts.variables);
  
  fprintf('CTROptimize: Optimization finished with err = %f.\n', err);
  fprintf('CTROptimize: Elapsed time %.2f seconds.\n', toc);
  
end

function res = target_res(x_, ctr_, HG, targets, vector, anatomy, mopts, output_directory, torsional_compliance)

  global debug;
  global iter;
  global workspace;
  
  % Grab the parameters from x_ and update the ctr structure
  [ctr_ T] = CTRCreateCTRFromMinimizationVector(x_, ctr_, mopts.variables);
  HG(1:3, 4) = T(1:3);
  
  % Solve the inverse kinematics by optimizing for the angles and lengths
  % This is Equation (18)
  [h res ctr] = CTREvaluate(ctr_, HG, anatomy, targets, vector, mopts.method, torsional_compliance);
  fprintf('Individual errors: %f\n', res);
  % Penalize inability to reach the target
  res = sum(res);
  
  % Penalize curvatures and total maximum length of third tube (max
  % extension)
  % All should be in the same range
  lengths = zeros(1, length(ctr));
  for idx = 1:length(ctr)
    temp = [ctr{idx}.length];
    lengths(idx) = temp(end) + temp(end - 1);
  end
  
  res = res + max(lengths) + sum([ctr_(:).u]);
  
  % Save results in the file
  if debug
    hold on;
    plot_workspace(workspace);
    hold off;
    str = sprintf('Current error: %f, Iteration: %d', res, iter);
    title(str);
    view(4, 4);
    % axis([.04 .11 .06 .12 .08 .15]); 
    save_figure(h, [to_dir(output_directory) 'images/minimization_' int2strz(iter, 6)], 'png');   
    % save_figure(h, [to_dir(output_directory) 'images/minimization_' int2strz(iter, 6)], 'fig'); 
    pause(0.1);
  end
  
  CTRSaveResults([to_dir(output_directory) 'workspace/'], iter, res, ctr, T);
  
  iter = iter + 1;
  
end

