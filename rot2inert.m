function rv_inert = rot2inert(rv_rot, theta, origin, mu)
% rv_inert = rot2inert(rv_rot, theta, origin, mu)
% converts state vector from rotating frame to inertial frame
% Inputs:
%     rv_rot = [6xN] state vector [rx;ry;rz;vx;vy;vz] in rotating frame
%     theta = (scalar) radians rotated
%     origin = (string) 'BARY', 'PRIM', 'SEC' origin of inertial frame
% Outputs
%     rv_inert = [6xN] state vector [rx;ry;rz;vx;vy;vz] in inertial frame

[n,m] = size(rv_rot);
if n ~= 6
    if m == 6
        rv_rot = rv_rot';
        m = n;
    else
        error("rv_rot should be 6xN")
    end
end

if nargin < 4;      global mu;          end
if isempty(mu);     mu = 3.0404233e-06; end %Value for Europa/Jupiter System
if nargin < 3;      origin = "BARY";    end
if nargin < 2;      theta = 0;          end

if length(theta) == 1
    theta = theta*ones(1,m);
elseif iscolumn(theta)
    theta = theta';
end

rv_inert = zeros(6,m);
for i = 1:m
    A = [cos(theta(i)), -sin(theta(i)), 0;
        sin(theta(i)),  cos(theta(i)), 0;
        0,              0, 1];
    
    O = zeros(3);
    
    B = [-sin(theta(i)), -cos(theta(i)), 0;
        cos(theta(i)), -sin(theta(i)), 0;
        0,              0, 0];
    
    C = [A, O; B, A];
    
    rv_inert(:,i) = C * rv_rot(:,i);
    
    if upper(origin) == "BARY"
    elseif upper(origin) == "PRIM"
        r_offset  = -mu*[cos(theta(i)); sin(theta(i)); 0];
        v_offset  = -mu*[-sin(theta(i)); cos(theta(i)); 0];
        rv_offset = [r_offset; v_offset];
        rv_inert(:,i) = rv_inert(:,i)-rv_offset;
    elseif upper(origin) == "SEC"
        r_offset  = (1-mu)*[cos(theta(i)); sin(theta(i)); 0];
        v_offset  = (1-mu)*[-sin(theta(i)); cos(theta(i)); 0];
        rv_offset = [r_offset; v_offset];
        rv_inert(:,i) = rv_inert(:,i)-rv_offset;
    else
        error('origin must be BARY, PRIM, or SEC')
    end
end

%Changelog
%Date           Programmer              Action
%08/12/2019     Jared T. Blanchard      File created
%08/13/2019     Jared T. Blanchard      added origin
%08/14/2019     Jared T. Blanchard      Generalized for multiple vectors