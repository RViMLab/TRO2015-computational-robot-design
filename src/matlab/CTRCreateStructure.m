function [ctr s] = CTRCreateStructure(ctr_)
%
% FUNCTION
%   CTRCREATESTRUCTURE receives a concentric tube robots signature
%   structure and populates all the parameters based on the relationships
%   between the tubes. It will create all the neccessary segments, i.e. a
%   balanced pair is 2 curved sgments and 2 straight segments, and a fixed
%   curvature tube is a straight segment and a curved segment.
%
% USAGE
%   CTR = CTRCREATESTRUCTURE(CTR_).
%
% INPUT
%   CTR_: The signature concentric tube robot structure.
%
% OUTPUT
%   CTR: The updated concentric tube robot structure with all the
%   parameters filled in.
%     S: The potential curvature changing points that should be examined.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   2012.06.18
%

  if nargin < 1
    error('CTRCreateStructure: One input argument is required.');
  end
  
  % Find the number of segments
  n_segments = 0;
  for i = 1:length(ctr_)
    if strcmp(ctr_(i).type, 'balanced')
      n_segments = n_segments + 4;
    elseif strcmp(ctr_(i).type, 'fixed')
      n_segments = n_segments + 2;
    end
  end
  ctr = CTRCreateSegment();
    
  % "i" runs through the new structure
  i = 1;
  % "j" runs through the old structure
  j = 1;
  % all_end signifies the end point until now
  all_end = 0;
  % arclength points to examine
  s = 0;
  while i <= n_segments
  
    if strcmp(ctr_(j).type, 'balanced')
      
      % Curved segment #1
      ctr(i+2).id       = i + 2;
      ctr(i+2).u        = ctr_(j).u;
      ctr(i+2).u_temp   = ctr_(j).u;
      ctr(i+2).length   = ctr_(j).c_len;
      ctr(i+2).k        = ctr_(j).k(1);
      ctr(i+2).k_temp   = ctr_(j).k(1);
      ctr(i+2).diameter = ctr_(j).diameter;
      ctr(i+2).theta    = ctr_(j).theta(1);
      ctr(i+2).phi      = max(0, min(ctr_(j).phi, ctr_(j).c_len));
      ctr(i+2).start    = max(0, ctr(i+2).phi + all_end - ctr(i+2).length);
      ctr(i+2).end      = ctr(i+2).phi + all_end;
      
      % Curved segment #2
      ctr(i+3)       = ctr(i+2);
      ctr(i+3).id    = i+3;
      ctr(i+3).theta = ctr_(j).theta(2);
      if length(ctr_(j).k) == 2
        ctr(i+3).k = ctr_(j).k(2);
      end
        
      % Straight segment #1
      ctr(i).id       = i;
      ctr(i).u        = 0;
      ctr(i).u_temp   = 0;
      ctr(i).length   = max(0, ctr(i+2).end - ctr(i+2).length);
      ctr(i).k        = ctr_(j).k(1);
      ctr(i).k_temp   = ctr_(j).k(1);
      ctr(i).diameter = ctr_(j).diameter;
      ctr(i).theta    = ctr_(j).theta(1);
      ctr(i).phi      = NaN;
      ctr(i).start    = 0;
      ctr(i).end      = ctr(i).length;
      
      % Straight segment #2
      ctr(i+1)       = ctr(i);
      ctr(i+1).id    = i+1;
      ctr(i+1).theta = ctr_(j).theta(2);
      if length(ctr_(j).k) == 2
        ctr(i+1).k      = ctr_(j).k(2);
        ctr(i+1).k_temp = ctr_(j).k(2);
      end
      
      s = [s ctr(i+1).end ctr(i+3).end];
      all_end = ctr(i+3).end;     
      
      i = i + 4;
      
    end
    
    if strcmp(ctr_(j).type, 'fixed')
      
      % Curved segment
      ctr(i+1).id       = i + 1;
      ctr(i+1).u        = ctr_(j).u;
      ctr(i+1).u_temp   = ctr_(j).u;
      ctr(i+1).length   = ctr_(j).c_len;
      ctr(i+1).k        = ctr_(j).k;
      ctr(i+1).k_temp   = ctr_(j).k;
      ctr(i+1).diameter = ctr_(j).diameter;
      ctr(i+1).theta    = ctr_(j).theta;
      ctr(i+1).phi      = max(0, min(ctr_(j).phi, ctr_(j).c_len));
      ctr(i+1).start    = max(0, ctr(i+1).phi + all_end - ctr(i+1).length);
      ctr(i+1).end      = ctr(i+1).phi + all_end;
      
      % Straight segment
      ctr(i).id       = i;
      ctr(i).u        = 0;
      ctr(i).u_temp   = 0;
      ctr(i).length   = max(0, ctr(i+1).end - ctr(i+1).length);
      ctr(i).k        = ctr_(j).k;
      ctr(i).k_temp   = ctr_(j).k;
      ctr(i).diameter = ctr_(j).diameter;
      ctr(i).theta    = ctr_(j).theta;
      ctr(i).phi      = NaN;
      ctr(i).start    = 0;
      ctr(i).end      = ctr(i).length;
      
      s = [s ctr(i).end ctr(i+1).end];
      all_end = ctr(i+1).end;

      i = i + 2;
      
    end
    
    j = j + 1;
  
  end
  
  s = unique(s); % unique or sort are needed because s is not always increasing 
  % unique(round(1e+5*s)/1e+5);
  
end

function seg = CTRCreateSegment()
%
% FUNCTION
%   CREATE_SEGMENT allocates a structure with empty fields to hold the
%   parameters of a concentric tube robot segment.
%
% USAGE
%   SEG = CREATE_SEGMENT().
%
% OUTPUT
%   SEG: The created segment.
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   2012.06.19
%
  seg = struct('id',       [], ...
               'u',        [], ... % curvature
               'length',   [], ... % arclength
               'k',        [], ... % stiffness
               'diameter', [], ...
               'theta',    [], ...
               'phi',      [], ...
               'start',    [], ... % arc start
               'end',      [], ... % arc end
               'curve',    []);    % holds the curve

end