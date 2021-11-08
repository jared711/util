% setOberon
% 
% model for Uranus-Oberon CR3BP system
% 
% Record of Revision
% Date          Programmer          Description of Changes
% 01/23/2020    Jared T. Blanchard  Based off of Brian D. Anderson's
%                                   seteuropaglobal code
global mu URANUS OBERON SUN PRIM SEC AU RUNIT TUNIT VUNIT AUNIT

disp('Set URANUS-OBERON System');
SUN.name        = 'SUN';
SUN.gm          = 132712440017.986999511718750000; % km^3/s^2
SUN.radius      = 6.955e5;                      % km (approximate value)

PRIM.name       = 'URANUS';
PRIM.gm         = 5793951.3;                  % km^3/s^2  (+-2.7  )   http://ssd.jpl.nasa.gov/?gravity_fields_op
PRIM.gmbary     = 5794556.5;                  % km^3/s^2  (+-2.7  )   http://ssd.jpl.nasa.gov/?gravity_fields_op
PRIM.radius     = 25559;                        % km        (+-4    )   http://ssd.jpl.nasa.gov/?planet_phys_par
PRIM.j2         = 3510.7e-6;                  % unitless  (+-0.29e-6) http://ssd.jpl.nasa.gov/?gravity_fields_op
PRIM.period     = 84.016846 * 365.25 * 86400;   % sec       (+-?    )   http://ssd.jpl.nasa.gov/?planet_phys_par
PRIM.sm         = ((SUN.gm + PRIM.gmbary) * (PRIM.period / (2 * pi)) ^ 2) ^ (1 / 3); % km
PRIM.rot        = 1 / (-0.71833);                  % Rev/Day   (+-?    )   http://ssd.jpl.nasa.gov/?planet_phys_par
PRIM.rotD       = PRIM.rot * 360 / 86400;       % Deg/Sec   (+-?    )
PRIM.color      = [0,1,1];
PRIM.img        = "uranus.jpg";

SEC.name        = 'OBERON';
SEC.gm          = 205.3;                     % km^3/s^2  (+-5.8 )   http://ssd.jpl.nasa.gov/?sat_phys_par
SEC.radius      = 761.4;                        % km        (+-2.6 )   http://ssd.jpl.nasa.gov/?sat_phys_par
SEC.sm          = 583400;                       % km        (+-?    )   http://ssd.jpl.nasa.gov/?sat_elem
SEC.ecc         = 0.001;                       % unitless  (+-?    )   http://ssd.jpl.nasa.gov/?sat_elem
SEC.period      = 13.463606 * 86400;                % sec       (+-?    )   http://ssd.jpl.nasa.gov/?sat_elem
SEC.rot         = 2 * pi / SEC.period;          % rad/s synchronous     JUP310
SEC.color       = [0.2,0.2,0.2];

SEC.mu          = SEC.gm / (SEC.gm + PRIM.gm);
mu              = SEC.mu;

AU              = 149597927.000;                % km

OBERON         = SEC;
URANUS          = PRIM;

RUNIT           = SEC.sm;
TUNIT           = SEC.period / (2 * pi);
VUNIT           = RUNIT / TUNIT;
AUNIT           = RUNIT / TUNIT ^ 2;
