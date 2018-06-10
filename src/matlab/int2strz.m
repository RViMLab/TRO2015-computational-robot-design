function S = int2strz(X,N)
%INT2STRZ Converts integer to string padding with zeros at the right.
%   Y = INT2STRZ(X) same as INT2STR but pads with zeros to the right in
%   those elements with less digits than the maximum element. The output is
%   a column vector.  
%
%   Y = INT2STRZ(X,N) padds with zeros up to N digits to the right. It is
%   ignored if the maximum integer has more digits.
%
%   Example:
%      If X = [0 1 11 111]
%      then int2strz(X)   = ['000'; '001'; '011'; '111']
%      and  int2strz(X,5) = ['00000'; '00001'; '00011'; '00111'] 
%
%   See also INT2STR, NUM2STR, SPRINTF

%   Written by
%   M.S. Carlos Adrian Vargas Aguilera
%   Physical Oceanography PhD candidate
%   CICESE 
%   Mexico, 2004-2006-2007-2008
%   nubeobscura@hotmail.com
%
%   Download from:
%   http://www.mathworks.com/matlabcentral/fileexchange/loadAuthor.do?objec
%   tType=author&objectId=1093874

if any(~isfinite(X)) || any(~isnumeric(X))
 error('Int2strz:InputType','Input must be numeric and finite.')
end

if nargin == 2
 % Make sure input is an integer:
 if any([~isnatural(N(:)); (numel(N)~=1); (N(:)<0)])
  error('Int2strz:InputType','Optional input must be a positive integer.')
 end
else 
 N = 0;
end

% Number of digits 
M = 1;             % (bug fixed, feb.2008)
xmax = double(max(abs(X(:))));           % allows integer inputs
if xmax>=1
 M = M + floor(log10(xmax));               
 if M<N, M = N; end
else
 M = M+1;
end
S = sprintf(['%0' int2str(M) '.0f'],round(X(:)));
S = reshape(S,M,numel(X)).';


function yes = isnatural(n)
%ISNATURAL   Checks if an array has natural numbers.
%   Y = ARENATURAL(X) returns an array of the same size as X with ones in
%   the elements of X that are natural numbers (...-2,-1,0,1,2,...), and 
%   zeros where not.

%   Written by
%   M.S. Carlos Adrián Vargas Aguilera
%   Physical Oceanography PhD candidate
%   CICESE 
%   Mexico, november 2006
% 
%   nubeobscura@hotmail.com

yes = (n==floor(n)).*isreal(n).*isnumeric(n).*isfinite(n);


% Carlos Adrián. nubeobscura@hotmail.com