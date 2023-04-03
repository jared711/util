function setearthmoon(ln)
% setearthmoon(ln)
% 
% model for Sun-Earth/Moon CR3BP system
% 
% ln defines the lagrange point number as origin, ln=0 sets origin as CR3BP
% origin (system barycenter). ln=0 is the default if none is specified.
% 
% Record of Revision
% Date          Programmer          Description of Changes
% 10/04/2022    Jared T. Blanchard  Original Code

global mu AU EARTH SUN MOON PRIM SEC RUNIT TUNIT VUNIT AUNIT

disp('Set Sun-Earth/Moon System');
SUN.name        = 'SUN';
SUN.gm          = 132712440017.986999511718750000; % km^3/s^2
SUN.radius      = 6.955e5;                      % km (approximate value)

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

AU           = EARTH.sm;

MOON.name        = 'MOON';
MOON.gm          = 4902.801;                     % [km^3/s^2]  (+-0.001)   http://ssd.jpl.nasa.gov/?sat_phys_par
MOON.radius      = 1737.5;                       % [km]        (+-0.1  )   http://ssd.jpl.nasa.gov/?sat_phys_par
MOON.sm          = 384400;                       % [km]        (+-?    )   http://ssd.jpl.nasa.gov/?sat_elem
MOON.ecc         = 0.0554;                       % [unitless]  (+-?    )   http://ssd.jpl.nasa.gov/?sat_elem
MOON.period      = 27.322 * 86400;               % [MOON]       (+-?    )   http://ssd.jpl.nasa.gov/?sat_elem
MOON.rot         = 2 * pi / MOON.period;          % [rad/s] synchronous
MOON.color       = [0.6,0.6,0.6];                % Grey
MOON.img        = "moon.jpg";

MOON.mu          = MOON.gm / (MOON.gm + EARTH.gm);
mu              = (EARTH.gmbary)/(SUN.gm+EARTH.gmbary);

PRIM = SUN;

SEC.name   = 'EARTH/MOON';
SEC.gm     = EARTH.gmbary;          % [km^3/s^2]SUN
SEC.sm     = 149597927.000; % km
SEC.period = 31556924.867; % sec
SEC.radius = 6378.136d0;

RUNIT           = SEC.sm;
TUNIT           = SEC.period / (2 * pi);
VUNIT           = RUNIT / TUNIT;
AUNIT           = RUNIT / TUNIT ^ 2;

end