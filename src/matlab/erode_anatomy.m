function [anatomy_out distance_trans] = erode_anatomy(anatomy, diameters, tolerance)
%
% FUNCTION
%   ERODE_ANATOMY receives a binarized anatomy volume where '0' corresponds
%   to forbidden regions. The output is the eroded version of the anatomy
%   based on a given concentric tube robot diameter.
%
% USAGE
%   [ANATOMY_OUT DISTANCE_TRANS] = ERODE_ANATOMY(ANATOMY, DIAMETERS, TOLERANCE).
%
% INPUT
%   ANATOMY: Binary volume corresponding to forbidden and allowed regions.
%   DIAMETERS: Diameters to be used for erosion.
%   TOLERANCE: Tissue and vessels can flex. This value is subtracted from
%   the erosion diameter calculation.
% 
% OUTPUT
%   ANATOMY_OUT: The eroded anatomy.
%   DISTANCE_TRANS: Distance transforms.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   2012.09.07
%

  if nargin < 3
    tolerance = 0.125e-3;
    fprintf('ERODE_ANATOMY: Setting tolerance to 0.125mm.\n');
  end
  if nargin < 2
    error('ERODE_ANATOMY: At least two input arguments are required.');
  end

  % Create one eroded anatomy for each given diameter
  anatomy_out = zeros([size(anatomy), length(diameters)]);
  distance_trans = zeros([size(anatomy), length(diameters)]);
  
  for j = 1:length(diameters)
    
    r = round(sitoanatomy(0.5*diameters(j) - tolerance, 1e-3));
    el = strel('disk', r);
    
    for i = 1:size(anatomy, 3)
      
      % Hack to fill in space
      for k = 1:6
        anatomy_out(:, :, i, j) = imdilate(anatomy(:, :, i), el);
        anatomy(:, :, i) = anatomy_out(:, :, i, j);
      end
      for k = 1:6
        anatomy_out(:, :, i, j) = imerode(anatomy(:, :, i), el);
        anatomy(:, :, i) = anatomy_out(:, :, i, j);
      end
      
      anatomy_out(:, :, i, j) = imerode(anatomy(:, :, i), el);
      distance_trans(:, :, i, j) = 1./(bwdist(~anatomy_out(:, :, i, j)) + eps);
      
    end
    
  end
  
end
