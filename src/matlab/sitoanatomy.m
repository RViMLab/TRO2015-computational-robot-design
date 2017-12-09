function an_val = sitoanatomy(si_val, res)
%
% FUNCTION
%   SITOANATOMY converts from value SI_VAL from the SI system to whatever
%   the discretized system of the anatomical model is, based on resolution
%   RES.
%
% USAGE
%   AN_VAL = SITOANATOMY(SI_VAL, RES).
%
% INPUT
%   SI_VAL: Vector containing the values to be converted.
%   RES: The resolution that takes you to the discretized space.
%
% OUTPUT
%   AN_VAL: The values in the anatomy "metric" system.
%
% AUTHOR
%   Christos Bergeles
% 
% DATE
%   2012.06.04
%

  if nargin < 2
    res = 1e-3;
  end
  
  if nargin < 1
    error('SITOANATOMY: At least one input argument is required.');
  end
  
  an_val = si_val(:)/res;
  
  an_val = reshape(an_val, size(si_val));

end