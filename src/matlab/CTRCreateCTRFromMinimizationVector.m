function [ctr HG] = CTRCreateCTRFromMinimizationVector(x, ctr_, mopts)
%
% FUNCTION
%   CTRCREATECTRFROMMINIMIZATIONVECTOR reads a minimization vector X that
%   was created by CTRCREATEMINIMIZATIONVECTOR and adjusts the parameters
%   of the concentric tube robot CTR_. MOPTS contains the parameters we
%   care about as strings.
%
% USAGE
%   [CTR HG] = CTRCREATECTRFROMMINIMIZATIONVECTOR(X, CTR_, MOPTS).
%
% INPUT
%   X: The vector containing the parameters to be used.
%   CTR_: The (simple) concentric tube robot structure.
%   MOPTS: Cell of strings containing what should be minimized for.
%
% OUTPUT
%   CTR: The updated concentric tube robot structure.
%   HG: The updated base location.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   2012.06.19
%

  if nargin < 3
    error('CTRCreateCTRFromMinimizationVector: Three input arguments are required.');
  end
  
  mopts = sort(mopts); 
  ctr = ctr_;
  
  % this will guarantee length - curvature - base order
  for i = length(mopts):-1:1
    switch mopts{i}
      case 'lengths'
      
        lengths = x(1:2*length(ctr));
        x(1:2*length(ctr)) = [];
        
        for j = 1:2:length(lengths)
          
          ctr(ceil(j/2)).s_len = lengths(j);
          ctr(ceil(j/2)).c_len = lengths(j+1);
          
        end
      
      case 'lengths_curved'
        
        lengths = x(1:length(ctr));
        x(1:length(ctr)) = [];
        
        for j = 1:length(lengths)
          
          ctr(j).c_len = lengths(j);
          
        end
        
      case 'curvatures'
        
        curvatures = x(1:length(ctr));
        x(1:length(ctr)) = [];
        
        for j = 1:length(curvatures)
          
          ctr(j).u = curvatures(j);
          
        end
        
      case 'base'
        
        HG = x(1:3);
        x(1:3) = [];
        
    end
  end

end
