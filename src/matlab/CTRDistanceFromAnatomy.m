function val = CTRDistanceFromAnatomy(fullCTR, anatomy)
%
% FUNCTION
%   CTRDISTANCEFROMANATOMY checks the given full concentric tube robot and
%   returns how "far" overall it is from the anatomy using distance
%   transform metrics.
%
% USAGE
%   VAL = CTRDISTANCEFROMANATOMY(CURVE, ANATOMY).
%
% INPUT
%   fullCTR: The curve of the concentric tube robot.
%   ANATOMY: Structure containing the binarized and shrunk anatomy.
%
% OUTPUT
%   VAL: The overall distance from the anatomy metric. Shoud be minimized.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   2012.08.21
%

  if nargin < 2
    error('CTRDistanceFromAnatomy: Two input arguments are required.');
  end
  
  row_el = anatomy.row_el;
  col_el = anatomy.col_el;
  dep_el = anatomy.dep_el;
  
%   tempX = sitoanatomy(curve, 1e-3);
%   tempX = round(tempX);
%   
%   I = (tempX(3, :) - 1)*row_el*col_el + (tempX(2, :) - 1)*row_el + tempX(1, :);    % Find the points on the curve that intersect with the anatomy
%   
%   % Find the points on the curve that intersect with the anatomy
%   val = sum(anatomy.bwdist(I));
  
  val = 0;
  for i = 1:length(fullCTR)
    
    if isempty(fullCTR(i).curve)
      continue;
    end
  
    tempX = sitoanatomy(fullCTR(i).curve, 1e-3);
    tempX = round(tempX);
    
    I = (i - 1)*row_el*col_el*dep_el + (tempX(3, :) - 1)*row_el*col_el + (tempX(2, :) - 1)*row_el + tempX(1, :);    % Find the points on the curve that intersect with the anatomy
    
    len = sum(I < 1) + sum(I > length(anatomy.bwdist(:)));
    I(I < 1) = 1;
    I(I > length(anatomy.bwdist(:))) = length(anatomy.bwdist(:));
    
    val = val + sum(anatomy.bwdist(I)) + 1e+3*len;
    
  end
  
end