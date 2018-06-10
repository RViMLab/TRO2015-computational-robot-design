
% Code that performs optimization of a concentric tube robot parameters
% based on given anatomical constraints.
%
% AUTHORS:
%   Andrew Gosline
%   Christos Bergeles
%
% DATE:
%   2012.05.23
%   2018.06.10
%
% COPYRIGHT:
%   Boston Children's Hospital, Harvard Medical School
%   University College London
%
% All values are in metric system units ([m], [N], [radians] etc.)
%

close all hidden
clear variables
clc

global debug;
debug = true;

path(path, 'tubeplot');
path(path, 'fminsearchbnd');

%% Preparation

scenario = 'trachea';

% Anatomy
anatomy.filename = ['../../data/' scenario '/anatomy.mat'];

% Allowed base locations
load(['../../data/' scenario '/base.mat'], 'base');
  
% Targets
load(['../../data/' scenario '/targets.mat'], 'targets');

% Vector of the anatomical targets patch
load(['../../data/' scenario '/vectors.mat'], 'vectors');

% Orientation entry vector
load(['../../data/' scenario '/R.mat'], 'R');

mopts.variables = {'lengths_curved', 'curvatures', 'base'};
mopts.method = 'fminsearchbnd';

%% Plot requirements

figure(1);
plot_anatomy(anatomy.filename);
hold on;
quiver3(targets(1), targets(2), targets(3), vectors(1), vectors(2), vectors(3), 0.005, 'LineWidth', 2)
plot_workspace(base);
plot_target_points(targets);
hold off;
title('Anatomical and Surgical Constraints');
xlabel('x')
ylabel('y')
zlabel('z')
view(45, 45);

%% Kinematics

H = zeros(4, 4);
H(1:3, 1:3) = R;
H(1:3, 4)   = mean(base.workspace)';
H(4, 4)     = 1;
   
ctr_ = [];
i = 1;
ctr_(i).type      = 'fixed';

ctr_(i).u         = 20;
ctr_(i).u_min     = 0;
ctr_(i).u_max     = 100;

ctr_(i).c_len     = 25e-3; % curved length
ctr_(i).c_len_min = 10e-3;
ctr_(i).c_len_max = 300e-3;

ctr_(i).k         = 10;
ctr_(i).diameter  = 2.0e-3;
ctr_(i).theta     = pi/0.8;
ctr_(i).phi       = 0.010;

i = 2;
ctr_(i).type      = 'fixed';

ctr_(i).u         = 45;
ctr_(i).u_min     = 0;
ctr_(i).u_max     = 100;

ctr_(i).c_len     = 25e-3; % curved length
ctr_(i).c_len_min = 10e-3;
ctr_(i).c_len_max = 300e-3;

ctr_(i).k         = 1;
ctr_(i).diameter  = 2.0e-3;
ctr_(i).theta     = pi;
ctr_(i).phi       = 0.064;

i = 3;
ctr_(i).type      = 'fixed';

ctr_(i).u         = 45;
ctr_(i).u_min     = 0;
ctr_(i).u_max     = 100;

ctr_(i).c_len     = 25e-3; % curved length
ctr_(i).c_len_min = 10e-3;
ctr_(i).c_len_max = 300e-3;

ctr_(i).k         = 0.1;
ctr_(i).diameter  = 2.0e-3;
ctr_(i).theta     = pi;
ctr_(i).phi       = 0.064;

%% Plot initialisation

close all hidden
% Populate the concentric tube robot structure
[end_effector, curve, ctr] = CTRKinematics(ctr_, H);

figure(1);
CTRPlot(ctr);
hold on;
plot_anatomy(anatomy.filename);
quiver3(targets(1), targets(2), targets(3), vectors(1), vectors(2), vectors(3), 0.005, 'LineWidth', 2)
quiver3(H(1, 4), H(2, 4), H(3, 4), R(1, 3), R(2, 3), R(3, 3), 0.005, 'LineWidth', 2)
plot_workspace(base);
plot_target_points(targets);
hold off;
title('Anatomical and Surgical Constraints');
xlabel('x')
ylabel('y')
zlabel('z')
view(45, 45);

%% Optimize

[ctr_, err] = CTROptimize(ctr_, H, anatomy, targets, vectors, base, mopts);


