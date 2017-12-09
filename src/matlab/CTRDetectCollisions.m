function X = CTRDetectCollisions(fullCTR, anatomy)
%
% FUNCTION
%   CTRDETECTCOLLISIONS checks if the given full concentric tube robot hits
%   the given ANATOMY.
%
% USAGE
%   X = CTRDETECTCOLLISIONS(FULLCTR, ANATOMY).
%
% INPUT
%   FULLCTR: The full size concentric tube robot structure.
%   ANATOMY: Structure containing the binarized and shrunk anatomy.
%
% OUTPUT
%   X: The 4xN points of collision
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   2012.08.21
%

  if nargin < 2
    error('CTRDetectCollisions: Two input arguments are required.');
  end
  
  X = [];
  row_el = anatomy.row_el;
  col_el = anatomy.col_el;
     
  for i = 1:length(fullCTR)
      
    if isempty(fullCTR(i).curve)
      continue;
    end

    tempX = sitoanatomy(fullCTR(i).curve, 1e-3);
    tempX = round(tempX);
    
    % binary = anatomy.binary(:, :, :, i);
    
    % Make sure to avoid out-of-bounds errors
    tempX(1, tempX(1, :) > size(anatomy.binary, 1)) = 1;
    tempX(2, tempX(2, :) > size(anatomy.binary, 2)) = 1;
    tempX(3, tempX(3, :) > size(anatomy.binary, 3)) = 1;
    tempX(1, tempX(1, :) < 1) = 1;
    tempX(2, tempX(2, :) < 1) = 1;
    tempX(3, tempX(3, :) < 1) = 1;

    I = (tempX(3, :) - 1)*row_el*col_el + (tempX(2, :) - 1)*row_el + tempX(1, :);    % Find the points on the curve that intersect with the anatomy
    tempX = tempX(:, anatomy.binary(I) == 0);

    % I = sub2ind(size(binary), tempX(1, :), tempX(2, :), tempX(3, :));
    % Find the points on the curve that intersect with the anatomy
    % tempX = tempX(:, binary(I) == 0);
    
    X = [X tempX];
    
  end

  X = sitoanatomy(X, 1e+3);
  
end