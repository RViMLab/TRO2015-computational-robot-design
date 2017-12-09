function [end_effector curve ctr] = CTRKinematics(ctr_, H, n_divs)
%
% FUNCTION
%   CTRKINEMATICS calculates the forward kinematics of a concentric tube
%   robot based on the given parameters.
%
% USAGE
%   [END_EFFECTOR CURVE CTR] = CTRKINEMATICS(CTR, H, N_DIVS).
%
% INPUT
%   CTR_: Structure containing the concentric tube robot segments.
%   H: Base location and entry vector.
%   N_DIVS: Number of discretization steps along a curvature segment.
%
% OUTPUT
%   END_EFFECTOR: 4x4 pose of the end effector.
%   CURVE: The curve of the robot.
%   CTR: The updated concentric tube robot structure with all the sections.
%
% AUTHORS
%   Andrew Gosline
%   Christos Bergeles
%
% DATE
%   2012.06.19
%

  if nargin < 2
    error('CTRKinematics: Two input arguments are required.');
  end
  
  [ctr s] = CTRCreateStructure(ctr_);
  
  segms = length(s) - 1;
  if nargin < 3
    n_divs = 30;
  end
  
  for i = 1:length(ctr)
    ctr(i).curve = [];
  end
  
  % Concentric tube robot points
  P = zeros(4, (n_divs + 1)*segms);
  pt_idx = 1;
  % Find overlaps
  for i = 1:segms
    
    idx = find(s(i) >= [ctr(:).start] & s(i) < [ctr(:).end]);

    L = s(i + 1) - s(i);
    
    % Sum the stiffnesses
    k = sum([ctr(idx).k]);
    
    u = [0; 0];
    for t = 1:length(idx)
      u = u + ctr(idx(t)).k*Rz(ctr(idx(t)).theta)*[0; ctr(idx(t)).u];
    end
    u = u/k;
    
    % End effector is at the starting point
    [x, y, z, H] = estimate_curve(u, L, H, n_divs);

    P(:, pt_idx:(pt_idx + length(x) - 1)) = [x y z ones(size(x))]';
    pt_idx = pt_idx + length(x);
    
    % Find where to store the curve
    [~, max_diam_idx] = max([ctr(idx).diameter]);
    ctr(idx(max_diam_idx)).curve = [ctr(idx(max_diam_idx)).curve [x y z ones(size(x))]'];   
    
  end
  
  end_effector = H;
  
  curve = P;
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x, y, z, E_end] = estimate_curve(u, L, E_start, n_divs)

    E_total = E_start;
    
    n_pt = n_divs + 1;
    
    x = zeros(n_pt, 1);
    y = zeros(n_pt, 1);
    z = zeros(n_pt, 1);
    
    E = curve2matrix([u; 0], L/n_divs);  

    for i = 1:n_pt

        x(i) = E_total(1, 4); 
        y(i) = E_total(2, 4); 
        z(i) = E_total(3, 4); 
        
        E_total = E_total*E;
        
    end 
    
    E_end = E_start*E^(n_divs);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function M = curve2matrix(u,ds)

    [Z,theta] = curve2twist(u,ds);
    M         = twist2matrix(Z,theta);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Z,theta] = curve2twist(u,ds)
    un = norm(u);
    if un == 0
        w = [0 0 0]';
        v = [0 0 1]';
        theta = ds;
    else
        w = u/un;        
        v = [ 0 0 1 ]';
        v = v/un;
        theta = un*ds;         
    end  
    Z = [v; w];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function M = twist2matrix(Z,theta)

    M  = eye(4);
    I3 = eye(3);
    v  = Z(1:3);
    w  = Z(4:6);
    
    if norm(w) == 0
        M(1:3,4) = theta*v;     
    else
        W = [   0 -w(3) w(2)
              w(3)   0 -w(1)
             -w(2) w(1)   0 ];
        R = I3 + (W)*sin(theta) + (W^2)*(1-cos(theta));
 
        M(1:3,1:3) = R;
        
        % Cross product
        z = zeros(3, 1);
        z(1) = w(2)*v(3) - w(3)*v(2);
        z(2) = w(3)*v(1) - w(1)*v(3);
        z(3) = w(1)*v(2) - w(2)*v(1);
        
        p = (I3 - R)*z + theta*(w*w')*v;
        
        M(1:3,4) = p;
    end 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function M = Rz(theta)

    M = [ cos(theta) -sin(theta)
          sin(theta)  cos(theta) ];

end

