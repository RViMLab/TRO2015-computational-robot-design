function simpleCTR = CTRCreateSimpleCTRFromFullCTR(fullCTR)
%
% FUNCTION
%   CTRCreateSimpleCTRFromFullCTR receives a full concentric tube robot
%   sequence of segments and returns the compact version.
%
% USAGE
%   simpleCTR = CTRCreateSimpleCTRFromFullCTR(fullCTR).
%
% INPUT
%   fullCTR: The full concentric tube robot structure.
%
% OUTPUT
%   simpleCTR: The simplified concentric tube robot structure.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   2012.07.19
%

  if nargin < 1
    error('CTRCreateSimpleCTRFromFullCTR: One input argument is required.');
  end
  
  % Make the basic ctr_simple structure. If you encounter 2 NaN values for phi, 
  % you are parsing a balanced pair. If you encounter 1 NaN value, you are
  % parsing a fixed curvature segment.
  simple_ctr_segments = 0;
  n_segments = length(fullCTR);
 
  simpleCTR = [];
  i = 1;
  phis = [fullCTR(:).phi];
  thetas = [fullCTR(:).theta];
  while i <= n_segments
    
    if isnan(phis(i))
      if isnan(phis(i+1))
        simple_ctr_segments = simple_ctr_segments + 1;
        simpleCTR(simple_ctr_segments).type      = 'balanced';

        simpleCTR(simple_ctr_segments).u         = fullCTR(i+2).u;
        simpleCTR(simple_ctr_segments).c_len     = fullCTR(i+2).length;
        
        simpleCTR(simple_ctr_segments).k         = fullCTR(i+2).k;
        simpleCTR(simple_ctr_segments).diameter  = fullCTR(i+2).diameter;
        simpleCTR(simple_ctr_segments).theta     = [thetas(i+2) thetas(i+3)];
        simpleCTR(simple_ctr_segments).phi       = phis(i+2);
        
        i = i + 4;
      else
        simple_ctr_segments = simple_ctr_segments + 1;
        simpleCTR(simple_ctr_segments).type      = 'fixed';

        simpleCTR(simple_ctr_segments).u         = fullCTR(i+1).u;
        simpleCTR(simple_ctr_segments).c_len     = fullCTR(i+1).length;
        
        simpleCTR(simple_ctr_segments).k         = fullCTR(i+1).k;
        simpleCTR(simple_ctr_segments).diameter  = fullCTR(i+1).diameter;
        simpleCTR(simple_ctr_segments).theta     = thetas(i+1);
        simpleCTR(simple_ctr_segments).phi       = phis(i+1);
        
        i = i + 2;
      end
    end

  end

end