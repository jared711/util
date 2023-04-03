function setmars(ln)
% setmars(ln)
% 
% model for Sun-Mars CR3BP system

% ln defines the lagrange point number as origin, ln=0 sets origin as CR3BP
% origin (system barycenter). ln=0 is the default if none is specified.
% 
% Record of Revision
% Date          Programmer          Description of Changes
% 2/23/2022    Jared T. Blanchard   Original code patterned after Brian Anderson's

global mu MARS SUN PRIM SEC AU RUNIT TUNIT VUNIT AUNIT G

% Masses and gravitational parameters are at https://ssd.jpl.nasa.gov/astro_par.html
AU = 1.495978707e8; %[km]
G = 6.67430e-20; %[km^3/kg*s^2]

SUN.name        = 'SUN';
SUN.gm          = 1.32712440041279419e11; % km^3/s^2
% SUN.gm          = 132712440017.986999511718750000; % km^3/s^2
SUN.radius      = 6.955e5;                      % km (approximate value)

MARS.name   = 'MARS';
MARS.gm     = 42828.375816;                 % [km^3/s^2]
MARS.sm     = AU*1.52371034;                % [km]
MARS.period = 5.931440991360000e+07;        % [s]
MARS.radius = 3389.5;                       % [km] From https://ssd.jpl.nasa.gov/tools/periodic_orbits.html#/periodic

% MARS.j2     = 0.001082627;
% MARS.j3     = -0.2536414d-5;
% MARS.flat   = 298.257;
% MARS.rotD   = 4.178074346064814d-03; % Deg/Sec
           % = 360.9856235000000      % [deg/day]
% MARS.rot    = 1.0027378430556;       % Rev/Day
% MARS.PM     = 3.3186912127897;       % Rad J2000
% MARS.PMD    = 190.1470000000000;     % Deg J2000
% MARS.nm     = 2*pi/MARS.period;     % [radians/sec] mean motion

PRIM = SUN;
SEC = MARS;

% mu = SEC.gm/(SEC.gm+PRIM.gm);
mu = 3.227154996101724E-7;  % [NON]  From https://ssd.jpl.nasa.gov/tools/periodic_orbits.html#/periodic
% RUNIT = SEC.sm;
RUNIT = 2.08321282e8; % [km] From https://ssd.jpl.nasa.gov/tools/periodic_orbits.html#/periodic
% TUNIT = SEC.period/(2*pi);
TUNIT = 8253622; % [s] From https://ssd.jpl.nasa.gov/tools/periodic_orbits.html#/periodic
VUNIT = RUNIT/TUNIT;
AUNIT = VUNIT/TUNIT;

% From https://ssd.jpl.nasa.gov/tools/periodic_orbits.html#/periodic
% Mass ratio 	3.227154996101724E-7
% Length unit, LU (km) 	208321282
% Time unit, TU (s) 	8253622
% Mars radius (km) 	3389.5

end
