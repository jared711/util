function setearth(ln)
% setearth(ln)
% 
% model for Sun-Earth CR3BP system
%      To set Sun-Earth/Moon Model for CR3BP, call setearthmoon.m
%      To set Earth-Moon model fro CR3BP, call setmoon.m

% ln defines the lagrange point number as origin, ln=0 sets origin as CR3BP
% origin (system barycenter). ln=0 is the default if none is specified.
% 
% Record of Revision
% Date          Programmer          Description of Changes
% 10/4/2022    Jared T. Blanchard   Original code patterned after Brian Anderson's

global mu EARTH SUN PRIM SEC AU RUNIT TUNIT VUNIT AUNIT

disp('To set Sun-Earth/Moon Model for RTBP, call setearthmoon.m');
% SUN.gm       = 132712440017.986999511718750000;
SUN.name        = 'SUN';
SUN.gm          = 132712440017.986999511718750000; % km^3/s^2
SUN.radius      = 6.955e5;                      % km (approximate value)

EARTH.name   = 'EARTH';
EARTH.gm     = 398600.432896939164493230;          % [km^3/s^2]SUN
EARTH.gmbary = 403503.233479;
EARTH.mu     = EARTH.gm/(SUN.gm+EARTH.gm);
EARTH.mubary = EARTH.gmbary/(EARTH.gmbary+SUN.gm);
EARTH.sm     = 149597870.691000015; % km
EARTH.period = 31556924.867; % sec
EARTH.radius = 6378.136d0;
EARTH.j2     = 0.001082627;
EARTH.j3     = -0.2536414d-5;
EARTH.flat   = 298.257;
EARTH.rotD   = 4.178074346064814d-03; % Deg/Sec
           % = 360.9856235000000      % [deg/day]
EARTH.rot    = 1.0027378430556;       % Rev/Day
EARTH.PM     = 3.3186912127897;       % Rad J2000
EARTH.PMD    = 190.1470000000000;     % Deg J2000
EARTH.nm     = 2*pi/EARTH.period;     % [radians/sec] mean motion

AU           = EARTH.sm;

PRIM = SUN;
SEC = EARTH;

mu = SEC.gm/(SEC.gm+PRIM.gm);
RUNIT = SEC.sm;
TUNIT = SEC.period/(2*pi);
VUNIT = RUNIT/TUNIT;
AUNIT = VUNIT/TUNIT;

end
