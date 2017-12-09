function [y y_min y_max] = CTRPackageVariables(ctr)

  y = [];
  y_min = [];
  y_max = [];
  % Stack kinematic variables in a vector
  for i = 1:length(ctr)
% NOTE TO ANDREW AND CHRIS  - Torsional compliance needs 0 to pi.  rigid
% needs -2pi to 2pi. to solve
    y = [y ctr(i).theta(:)' ctr(i).phi];
    y_min = [y_min -2*pi*ones(1, length(ctr(i).theta)) 0];
    y_max = [y_max +2*pi*ones(1, length(ctr(i).theta)) ctr(i).c_len];
    
  end

end
