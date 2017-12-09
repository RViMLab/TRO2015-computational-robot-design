function CTRSaveResults(direc, iter, err, ctr, base)
%
% FUNCTION
%   CTRSAVERESULTS saves the results and error of the current iteration
%   ITER as matlab files in the directory DIREC.
%
% USAGE
%   CTRSAVERESULTS(DIREC, ITER, ERR, CTR, BASE).
%
% INPUT
%   DIREC: The directory where the workspace is saved.
%   ITER: The current iteration number.
%   ERR: The residual at the current iteration.
%   CTR: The full concentric tube robot structure.
%   BASE: The base location.
%
% OUTPUT
%   The files are saved on the disk.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   2012.07.17
%

  if nargin < 5
    error('CTRSaveResults: At least five input arguments are required.');
  end
  
  fprintf('Time: %5.0f [sec], Iteration: %d, Error: %4.3f\n', toc, iter, err);
  
  % Save the current configuration
  time = toc;
  num_targets = length(ctr);
  
  file_str = [to_dir(direc) int2strz(iter, 5) '-iterations.mat'];
  save(file_str, 'time', 'num_targets', 'ctr', 'base', 'err');
  
end