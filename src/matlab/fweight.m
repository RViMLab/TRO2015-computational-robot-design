function x = fweight(y, val)
%
% FUNCTION
%   FWEIGHT applies an exponential function to the input value Y if its
%   value is larger than VAL.
%
% USAGE
%   X = FWEIGHT(Y, VAL).
%
% INPUT
%   Y: The input value.
%   VAL: The threshold.
%
% OUTPUT
%   X: The exponentially weighted value.
%
% AUTHOR
%   Andrew Gosline
%
% DATE
%   2012.06.06
%

  if nargin < 2
    error('FWEIGHT: Two input arguments are required.');
  end
  
  if (y > val)
    x = exp(10000*y);
  else
    x = y;
  end
  
end

