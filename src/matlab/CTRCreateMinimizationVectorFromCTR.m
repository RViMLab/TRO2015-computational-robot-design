function x = CTRCreateMinimizationVectorFromCTR(ctr, HG, mopts)
%
% FUNCTION
%   CTRCREATEMINIMIZATIONVECTORFROMCTR(CTR, MOPTS) creates a minimization
%   vector given a concentric tube robot CTR and directions on what to
%   minimize for MOPTS.
%
% USAGE
%   X = CTRCREATEMINIMIZATIONVECTORFROMCTR(CTR, HG, MOPTS).
%
% INPUT
%   CTR: An original (simple) concentric tube robot structure.
%   HG: Initial base position (can be []).
%   MOPTS: A cell of strings containing what to minimize for.
%
% OUTPUT
%   X: The vector with the minimization paremeters. The values are ordered
%   (1) curvatures, (2) lengths, (3) base.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   2012.06.19
%

  if nargin < 3
    error('CTRCreateMinimizationVectorFromCTR: Three input arguments are required.');
  end
  
  mopts = sort(mopts);
  
  for i = length(mopts):-1:1
    switch mopts{i}
      case 'lengths'
        x_.lengths = zeros(1, 2*length(ctr));
        for j = 1:length(ctr)
          x_.lengths(2*j-1:2*j) = [ctr(j).s_len; ctr(j).c_len];
        end
      case 'lengths_curved'
        x_.lengths_curved = [ctr(:).c_len];
      case 'curvatures'
        x_.curvatures = zeros(1, length(ctr));
        for j = 1:length(ctr)
          x_.curvatures(j) = ctr(j).u;
        end
      case 'base'
        x_.base = HG(:);
    end
  end
  
  % Vectorize
  x = [];
  if isfield(x_, 'lengths')
    x = [x; x_.lengths(:)];
  end
  if isfield(x_, 'lengths_curved')
    x = [x; x_.lengths_curved(:)];
  end
  if isfield(x_, 'curvatures')
    x = [x; x_.curvatures(:)];
  end
  if isfield(x_, 'base')
    x = [x; x_.base];
  end

end