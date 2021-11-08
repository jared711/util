function rvdot = CR3BP_inert(t, rv, origin, mu)
% Xdot = CR3BP_inert(t, X, mu)
% Inputs:
%     t = (scalar) time, used by ode function
%     rv = [6x1] state vector [rx;ry;rz;vx;vy;vz]
%     mu = (scalar) gravitational parameter
%     origin = (string) 'BARY', 'PRIM', 'SEC' origin of inertial frame
% Outputs:
%     rvdot = [6x1] vector [vx;vy;vz;ax;ay;az]

if nargin < 4;      global mu;                  end
if nargin < 3;      origin = "BARY";            end
if ~iscolumn(rv);   rv = rv';                   end
if length(rv) ~= 6; error('wrong size state');  end

r = rv(1:3);                        %position vector of P in inertial coords (also from m1 to P)
r12 = [cos(t);sin(t);0];            %position vector from m1 to m2

if upper(origin) == "BARY"
        r01 = [-mu*cos(t);-mu*sin(t);0];        %position vector from origin to m1
        r02 = [(1-mu)*cos(t);(1-mu)*sin(t);0];  %position vector from origin to m2
        r1 = r-r01;                             %position vector from m1 to P
        r2 = r-r02;                             %position vector from m2 to P
        offset = [0;0;0];                       %accounts for centrifugal force (none)
elseif upper(origin) == "PRIM"                    
        r1 = r;                                 %position vector from m1 to P
        r2 = r1 - r12;                          %position vector from m2 to P
        offset = mu*[cos(t);sin(t);0];          %accounts for centrifugal force
elseif upper(origin) == "SEC"
        r2 = r;                                 %position vector from m2 to P
        r1 = r2 + r12;                          %position vector from m1 to P
        offset = (1-mu)*[-cos(t);-sin(t);0];    %accounts for centrifugal force
else
    error("invalid origin; must be BARY, PRIM, SEC")
end

v = rv(4:6);
a = -(1-mu)/(norm(r1)^3)*r1 - mu/(norm(r2)^3)*r2 - offset;

rvdot(1:3) = v;
rvdot(4:6) = a;

%Changelog
%Date           Programmer              Action
%08/12/2019     Jared T. Blanchard      File created
%08/22/2019     Jared T. Blanchard      Added centrifugal force offset