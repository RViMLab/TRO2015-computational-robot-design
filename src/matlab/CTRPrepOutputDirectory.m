function output_directory = CTRPrepOutputDirectory()
%
% FUNCTION
%   CTRPREPOUTPUTDIRECTORY creates a directory based on the current date
%   and time, and create the necessary folders for the optimization history
%   loging, image loging, and configuration loging.
%
% USAGE
%   OUTPUT_DIRECTORY = CTRPREPOUTPUTDIRECTORY().
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   2012.07.12
%

  id_str = datestr(now, 'yyyymmddTHHMMSS');
  output_directory = strcat(to_dir(get_parent_directory()), to_dir('data'), to_dir(id_str));
  
  if ~exist(output_directory, 'dir')
    [~, ~] = mkdir(output_directory);
    warning('CTRPrepOutputDirectory: Creating the required directory.');
    fprintf('%s created.\n', output_directory);
  end

  image_directory = strcat(to_dir(output_directory), 'images');
  if ~exist(image_directory, 'dir')
    [~, ~] = mkdir(image_directory);
    warning('CTRPrepOutputDirectory: Creating the required directory.');
    fprintf('%s created.\n', image_directory);
  end
  
  mat_directory = strcat(to_dir(output_directory), 'workspace');
  if ~exist(mat_directory, 'dir')
    [~, ~] = mkdir(mat_directory);
    warning('CTRPrepOutputDirectory: Creating the required directory.');
    fprintf('%s created.\n', mat_directory);
  end
  
  fprintf('Copying configuration file.\n');
  copyfile('run_optimization.m', strcat(output_directory, 'run_optimization.m'));
  
  fprintf('Copying evaluation file.\n');
  copyfile('CTREvaluate.m', strcat(output_directory, 'CTREvaluate.m'));
  
  fprintf('Copying kinematics cost function.\n');
  copyfile('CTRInverseKinematics.m', strcat(output_directory, 'CTRInverseKinematics.m'));
  
end