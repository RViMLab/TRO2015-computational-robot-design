% This function creates a mat file given a STL, assumed to be in
% millimeters, of the geometry.
% ---------------------------------
% function [Binary, FV] = CTRCreateBinaryFromSTL(filelocationstring,plotstlstring, plotbinarystring);
%-------------------------
% Input1 is string containing file location to the stl file
% Input2 is string saying 'yes' if you want to plot the anatomy
% Output is a surface model in SI units (m) and a binary image of the
% anatomy for collision detection

function [binarymat, FV] = CTRCreateBinaryFromSTL(filelocationstring,plotstlstring, plotbinarystring);

if nargin < 2
    plotstlstring = 'noo';
    plotbinarystring = 'noo';
end

if nargin < 3
    plotbinarystring = 'noo';
end

%%
%data = stlread('../data/heartstlfiles/WZ/ZW 005-05-006s Posterior.stl');
data = stlread(filelocationstring);

%%
Tri = data.faces;
Pts = data.vertices;
%norms = CSFmodel.fn;

% Rotate the stl to align it with the co-ordinat axis if it seems useful
Ptsvec = [Pts ones(length(Pts),1)];

rotmatx = rotx(0.8);
rotmaty = roty(0.9);
rotmatz = rotz(0.0);

Ptsvecrotx = (rotmatx*rotmaty*rotmatz*Ptsvec')';

Pts = Ptsvecrotx(:,1:3);

% Look for the max and min to set up the binary matrix
min_Pts = min(Pts, [], 1);
max_Pts = max(Pts, [], 1);

Pts(:,1) = Pts(:,1) - (min_Pts(1))*1.1;
Pts(:,2) = Pts(:,2) - (min_Pts(2))*1.1;
Pts(:,3) = Pts(:,3) - (min_Pts(3))*1.1;

min_Pts = min(Pts, [], 1);
max_Pts = max(Pts, [], 1);

matrix_max = ceil(max_Pts) + 10;
matrix_min = zeros(1,3);

if (plotstlstring=='yes')
figure;
% Plot the Trisurf Data
axis equal;
%pbaspect ([1 1 1]);
rotate3d on;
nice3d;
trisurf(Tri,Pts(:,1),Pts(:,2),Pts(:,3),'EdgeColor',[ 0 0 0 ],'FaceColor',[1 0 0]);
view(0,0);
hold on;
end



%%
% This loop will go through each and every one of the vertices, round it, and set the corresponding locations in the binary matrix to 1 
binarymat = ones(matrix_max(1), matrix_max(2), matrix_max(3));
binarymat = logical(binarymat);

for i = 1:round(length(Pts))
    locX = round(Pts(i,1));
    locY = round(Pts(i,2));
    locZ = round(Pts(i,3));
    binarymat(locX, locY, locZ) = 0;
end
    

%%
if (plotbinarystring=='yes')
hold on
count = 1
for i = 1:size(binarymat,1)
    for j = 1:size(binarymat,2)
        for k = 1:size(binarymat,3)
             if binarymat(i,j,k) ==0
                plot3(i,j,k, 'k.');
            end
        end
    end
end
end

FV = [];

FV.vertices = Pts/1000;
FV.faces = Tri;
