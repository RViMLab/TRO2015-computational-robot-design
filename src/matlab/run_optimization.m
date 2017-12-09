
% Code that performs optimization of a concentric tube robot parameters
% based on given anatomical constraints.
%
% AUTHORS:
%   Andrew Gosline
%   Christos Bergeles
%
% DATE:
%   2012.05.23
%
% COPYRIGHT:
%   Boston Children's Hospital, Harvard Medical School
%
% All values are in metric system units ([m], [N], [radians] etc.)
%

close all hidden
clear variables

global debug;
debug = true;

%% Preparation

% scenario = 'atrium';
scenario = 'ventriclesHC';
% scenario = 'jugular';
% scenario = 'ventricles_occipital-entry';

% Anatomy
anatomy.filename = ['../data/' scenario '/anatomy.mat'];

% Allowed base locations
load(['../data/' scenario '/base.mat'], 'base');
  
% Targets
load(['../data/' scenario '/targets_all.mat'], 'targets');

% Vector of the anatomical targets patch
load(['../data/' scenario '/vector.mat'], 'vector');

% Orientation entry vector
load(['../data/' scenario '/R.mat'], 'R');

mopts.variables = {'lengths_curved', 'curvatures', 'base'};
mopts.method = 'fminsearchbnd';

targets = targets([2 3 4 5 6 7 1 8 9 10 11 12 13], :);

%% Kinematics

H = zeros(4, 4);
H(1:3, 1:3) = R;
H(1:3, 4)   = min(base.workspace)';
H(4, 4)     = 1;
   
ctr_ = [];
i = 1;
ctr_(i).type      = 'balanced';

ctr_(i).u         = 50;
ctr_(i).u_min     = 0;
ctr_(i).u_max     = 100;

ctr_(i).c_len     = 55e-3; % curved length
ctr_(i).c_len_min = 10e-3;
ctr_(i).c_len_max = 200e-3;

ctr_(i).k         = [5 5];
ctr_(i).diameter  = 3.0e-3;
ctr_(i).theta     = [2.7274 2.7274];
ctr_(i).phi       = 0.039;

i = 2;
ctr_(i).type      = 'fixed';

ctr_(i).u         = 45;
ctr_(i).u_min     = 0;
ctr_(i).u_max     = 100;

ctr_(i).c_len     = 65e-3; % curved length
ctr_(i).c_len_min = 10e-3;
ctr_(i).c_len_max = 200e-3;

ctr_(i).k         = 1;
ctr_(i).diameter  = 2.0e-3;
ctr_(i).theta     = -1;
ctr_(i).phi       = 0.064;

i = 3;
ctr_(i).type      = 'fixed';

ctr_(i).u         = 1e-10;
ctr_(i).u_min     = 1e-10;
ctr_(i).u_max     = 1e-10;

ctr_(i).c_len     = 10e-3;
ctr_(i).c_len_min = 10e-3;
ctr_(i).c_len_max = 200e-3;

ctr_(i).k         = 0.05;
ctr_(i).diameter  = 0.9*1e-3;
ctr_(i).theta     = 0;
ctr_(i).phi       = 0.023;

close all hidden
% Populate the concentric tube robot structure
[end_effector, curve, ctr] = CTRKinematics(ctr_, H);

figure(1);
plot_anatomy(anatomy.filename);
hold on;
CTRPlot(ctr);
plot_workspace(base);
plot_target_points(targets(5, :));
plot3(end_effector(1, 4), end_effector(2, 4), end_effector(3, 4), 'r+', 'MarkerSize', 25);
hold off;
view(45, 45);

%% Optimize

[ctr_ err] = CTROptimize(ctr_, H, anatomy, targets, vector, base, mopts);


