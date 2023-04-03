% Solar System Model from Quick 4/11/06
% USE: Set paramters for Earth. Return in EARTH in global.
%      To set Sun-Earth/Moon Model for RTBP, call setearth.m
% OUT: global AU EARTH
%      AU = EARTH.sm

global mu AU BODY EARTH MODEL SUN PRIM SEC RUNIT VUNIT TUNIT AUNIT

disp('Set constants for object EARTH ind AU n global');
disp('    To set Sun-Earth/Moon Model for RTBP, call setearth.m');
% SUN.gm       = 132712440017.986999511718750000;
SUN.gm       = 132712440017.986999511720000000;    % [km^3/s^2] Aug 2013
SUN.radius   = 696340; %[km[
SUN.color    = [1,1,0];

EARTH.name   = 'EARTH';
EARTH.gm     = 398600.432896939164493230;          % [km^3/s^2]SUN
EARTH.gmbary = 403503.233479;
EARTH.mu     = EARTH.gm/(SUN.gm+EARTH.gm);
EARTH.mubary = EARTH.gmbary/(EARTH.gmbary+SUN.gm);
EARTH.sm     = 149597927.000; % km
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
EARTH.color  = [0,0,1]; 
% AU           = EARTH.sm;
AU           = 149597870.691000015;   %[km]

PRIM = SUN;

SEC = EARTH;

MODEL = 'EarthModel';
mu = EARTH.mubary;

RUNIT = SEC.sm;
TUNIT = SEC.period / (2 * pi);
VUNIT = RUNIT / TUNIT;
AUNIT  = RUNIT / TUNIT ^ 2;

% Use setearth.m to get thee constants in the global.
%mu           = EARTH.mubary;
%BODY         = EARTH;
