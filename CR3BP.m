function rvdot = CR3BP(t, rv)
%Equations of motion for the Circular Restricted Three-Body Problem
%Input:
%   rv is Earth-centric ECI position

load('~/trajectory/beresheet/BeresheetMoonSunEphem.mat')

[m,n] = size(rv);

if m == 6 && n == 1
elseif m == 1 && n == 6
    rv = rv';
else
    error('rv should be size 6x1')
end

rE = rv(1:3);
rS = rE - pos_sun()

rvdot(1:3) = rv(4:6);
rvdot(4:6) = -muE*rE

% else
%     error('Wrong size state, should be 6x1 or 4x1')
end

%Changelog
%Date           Programmer              Action
%02/20/2019     Jared T. Blanchard      File created
