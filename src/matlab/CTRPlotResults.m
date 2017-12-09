function CTRPlotResults(direc)
%
% FUNCTION
%   CTRPLOTRESULTS reads the data from DIREC and plots the results during
%   convergence.
%
% USAGE
%   CTRPLOTRESULTS(DIREC).
%
% INPUT
%   DIREC: The path to the directory containing the data.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   20120.07.17
%

  if nargin < 2
    direc = uigetdir('../data/');
  end
  
  direc = to_dir(direc);
  
  if ~exist(direc, 'dir')
    error('CTRPlotResults: Chosen directory does not exist.');
  end
  
  files = dir([direc '*.mat']);
  
  [ctr_helper, ~] = CTRCreateCTRFromFile(1, 1, direc);
  [ctrhelper, ~] = CTRCreateStructure(ctr_helper);
  
  n_iterations = length(files);
  iterations = zeros(n_iterations, 1);
  times = zeros(n_iterations, 1);
  errs = zeros(n_iterations, 1);
  curvatures = zeros(n_iterations, length([ctrhelper(:).u]));
  lengths = zeros(n_iterations, length([ctrhelper(:).length]));
  bases = zeros(n_iterations, 3);
  
  for i = 1:n_iterations
    
    load([direc, files(i).name]); % This will create variables
    
    iterations(i) = i;
    times(i) = time;
%     if err > 2e+4
%       err = NaN;
%     end
    errs(i) = err;
    curvatures(i, :) = [ctr{1}(:).u];
    lengths(i, :) = [ctr{1}(:).length];
    bases(i, :) = base;
    
  end
    
  % Plot 
  % Error
  figure(1);
  % log scale
  semilogy(iterations, errs, 'r');
  title('Iterations vs Error');
  xlabel('Iterations');
  ylabel('Error');
  grid on
   
  % Base
  figure(2);
  subplot(3, 1, 1);
  plot(iterations, 1e+3*bases(:, 1), 'r');
  title('Iterations vs X-coordinate');
  xlabel('Iterations');
  ylabel('Base location [mm]');
  grid on;
  
  subplot(3, 1, 2);
  plot(iterations, 1e+3*bases(:, 2), 'g');
  title('Iterations vs Y-coordinate');
  xlabel('Iterations');
  ylabel('Base location [mm]');
  grid on;
  
  subplot(3, 1, 3);
  plot(iterations, 1e+3*bases(:, 3), 'b');
  title('Iterations vs Z-coordinate');
  xlabel('Iterations');
  ylabel('Base location [mm]');
  grid on;
  
  % Curvatures and lengths
  j  = 1;
  i = 1;
  while(j <= length(ctr_helper))
     
    if strcmp(ctr_helper(j).type, 'balanced')
       c = curvatures(:, i + 2); % Curvature of the one balanced tube
       c2 = curvatures(:, i + 3); 
       l = lengths(:, i + 2); % Length of the one balanced tube
       l2 = lengths(:, i + 3); % Length of the one balanced tube
       i = i + 4;
    elseif strcmp(ctr_helper(j).type, 'fixed')
       c = curvatures(:, i + 1); % Curvature of the curved part
       c2 = c;
       l = lengths(:, i + 1); % Length of the curved part
       l2 = l;
       i = i + 2;
    end  
    
    figure(j + 10);
    str = strcat(ctr_helper(j).type, '-', 'tube, #', num2str(j));
    subplot(2, 1, 1);
    plot(iterations, 1e-3*c);
    hold on;
    plot(iterations, 1e-3*c2, 'r.');
    hold off
    xlabel('Iterations');
    ylabel('Curvature [1/mm]');
    title(str);
    grid on;
    subplot(2, 1, 2)
    plot(iterations, 1e+3*l);
    hold on;
    plot(iterations, 1e+3*l2, 'r.');
    hold off;
    xlabel('Iterations');
    ylabel('Length [mm]');
    title(str);
    grid on;

    j = j + 1;
    
  end 
  
end
