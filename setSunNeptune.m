%% Set global constants

global mu AU EARTH NEPTUNE SUN RUNIT VUNIT TUNIT AUNIT PRIM SEC

% disp('Set global constants for Jupiter, Earth, and Sun');
SUN.name     = 'SUN';
% SUN.gm       = 132712440017.986999511718750000;
SUN.gm       = 132712440017.986999511720000000;    % Aug 2013
SUN.radius   = 696340;  % [km]
SUN.color    = [1,1,0];

NEPTUNE.name       = 'NEPTUNE';
NEPTUNE.gmbary     = 5794140.0361;                  % km^3/s^2  (+-2.7  )   http://ssd.jpl.nasa.gov/?gravity_fields_op
NEPTUNE.mubary     = NEPTUNE.gmbary/(NEPTUNE.gmbary + SUN.gm);
NEPTUNE.radius     = 24622;                        % km        (+-4    )   http://ssd.jpl.nasa.gov/?planet_phys_par
NEPTUNE.period     = 164.79132 * 365.25 * 86400;   % sec       (+-?    )   http://ssd.jpl.nasa.gov/?planet_phys_par
NEPTUNE.sm         = ((SUN.gm + NEPTUNE.gmbary) * (NEPTUNE.period / (2 * pi)) ^ 2) ^ (1 / 3); % km
NEPTUNE.color      = [0,0,1];
NEPTUNE.img        = "neptune.jpg";

EARTH.name   = 'EARTH';
EARTH.gm     = 398600.432896939164493230; % [km^3/s^2]          % [km^3/s^2]SUN
EARTH.gmbary = 403503.233479;             % [km^3/s^2]
EARTH.mu     = EARTH.gm/(SUN.gm + EARTH.gm);
EARTH.mubary = EARTH.gmbary/(EARTH.gmbary + SUN.gm);
EARTH.sm     = 149597927.000;   % [km]
EARTH.period = 31556924.867;    % [sec]
EARTH.radius = 6378.136;        % [km]
EARTH.j2     = 0.001082627;
EARTH.j3     = -0.2536414d-5;
EARTH.flat   = 298.257;
EARTH.rotD   = 4.178074346064814d-03; % [deg/sec]
EARTH.omega  = deg2rad(EARTH.rotD);   % [rad/sec]
           % = 360.9856235000000      % [deg/day]
EARTH.rot    = 1.0027378430556;       % Rev/Day
EARTH.PM     = 3.3186912127897;       % Rad J2000
EARTH.PMD    = 190.1470000000000;     % Deg J2000
EARTH.nm     = 2*pi/EARTH.period;     % [radians/sec] mean motion
EARTH.color  = [0,0,1]; 
AU           = EARTH.sm;
% AU           = 149597870.691000015;   %[km]

SUN.gmbary = SUN.gm + NEPTUNE.gmbary;

PRIM = SUN;
SEC = NEPTUNE;

mu = NEPTUNE.mubary;


RUNIT = NEPTUNE.sm;
TUNIT = NEPTUNE.period / (2 * pi);
VUNIT = RUNIT / TUNIT;
AUNIT  = RUNIT / TUNIT ^ 2;


