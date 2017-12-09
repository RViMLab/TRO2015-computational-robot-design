function [ctr_simple HT] = CTRCreateCTRFromFile(ind, target_idx, direc)
%
% FUNCTION
%   CTRCREATECTRFROMFILE reads the data from DIREC for iteration IND and
%   creates a simple concentric tube robot CTR_ and also return the base
%   location.
%
% USAGE
%   [CTR_SIMPLE HT] = CTRCREATECTRFROMFILE(ITERATION, TARGET_IDX, DIREC).
%
% INPUT
%   ITERATION: The design iteration you want to show.
%   TARGET_IDX: Which target point are you interested in?
%   DIREC: The path to the file containing the data.
%
% OUTPUT
%   CTR_SIMPLE : The basic original CTR before populating and calculating
%   curvature zones.
%   HT: The base location.
%
% AUTHOR
%   Christos Bergeles and Andrew Gosline
%
% DATE
%   20120.07.16
%

  if nargin < 3
    direc = uigetdir('../data/');
  end
  
  direc = to_dir(direc);
  
  if ~exist(direc, 'dir')
    error('CTRCreateCTRFromFile: Supplied directory does not exist.');
  end
  files = dir([direc '*mat']);
  
  if nargin < 2
    target_idx = 1;
  end
    
  if nargin < 1
    ind = -1;
  end
  if ind < 0
    ind = length(files);
  end
 
  load([direc, files(ind).name]);
  ctr_selected = ctr{target_idx};
  HT = base;
  
  ctr_simple = CTRCreateSimpleCTRFromFullCTR(ctr_selected);
   
end
