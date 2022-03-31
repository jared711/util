function seteuropa(ln)
% seteuropa(ln)
% 
% model for Jupiter-Europa CR3BP system
% 
% ln defines the lagrange point number as origin, ln=0 sets origin as CR3BP
% origin (system barycenter). ln=0 is the default if none is specified.
% 
% Record of Revision
% Date          Programmer          Description of Changes
% 08/25/2015    Brian D. Anderson   Original Code
% 01/23/2020    Jared T. Blanchard  Added color option

global mu e BODY JUPITER EUROPA SUN LN RL PRIM SEC AU RUNIT TUNIT VUNIT AUNIT

disp('Set JUPITER-EUROPA System');
SUN.name        = 'SUN';
SUN.gm          = 132712440017.986999511718750000; % km^3/s^2
SUN.radius      = 6.955e5;                      % km (approximate value)

PRIM.name       = 'JUPITER';
PRIM.gm         = 126686536.1;                  % km^3/s^2  (+-2.7  )   http://ssd.jpl.nasa.gov/?gravity_fields_op
PRIM.gmbary     = 126712764.1;                  % km^3/s^2  (+-2.7  )   http://ssd.jpl.nasa.gov/?gravity_fields_op
PRIM.radius     = 71492;                        % km        (+-4    )   http://ssd.jpl.nasa.gov/?planet_phys_par
PRIM.j2         = 14695.62e-6;                  % unitless  (+-0.29e-6) http://ssd.jpl.nasa.gov/?gravity_fields_op
% PRIM.j3         = 0;
PRIM.flat       = 0.06487;                      % unitless  (+-?    )   JUP310
PRIM.period     = 11.862615 * 365.25 * 86400;   % sec       (+-?    )   http://ssd.jpl.nasa.gov/?planet_phys_par
PRIM.sm         = ((SUN.gm + PRIM.gmbary) * (PRIM.period / (2 * pi)) ^ 2) ^ (1 / 3); % km
PRIM.rot        = 1 / 0.41354;                  % Rev/Day   (+-?    )   http://ssd.jpl.nasa.gov/?planet_phys_par
PRIM.rotD       = PRIM.rot * 360 / 86400;       % Deg/Sec   (+-?    )
PRIM.color      = [0.8,0.5,0.3];
PRIM.img        = "jupiter.jpg";

SEC.name        = 'EUROPA';
SEC.gm          = 3202.739;                     % km^3/s^2  (+-0.009)   http://ssd.jpl.nasa.gov/?sat_phys_par
SEC.radius      = 1560.8;                       % km        (+-0.5  )   http://ssd.jpl.nasa.gov/?sat_phys_par
SEC.sm          = 671100;                       % km        (+-?    )   http://ssd.jpl.nasa.gov/?sat_elem
SEC.ecc         = 0.0094;                       % unitless  (+-?    )   http://ssd.jpl.nasa.gov/?sat_elem
SEC.period      = 3.551 * 86400;                % sec       (+-?    )   http://ssd.jpl.nasa.gov/?sat_elem
SEC.rot         = 2 * pi / SEC.period;          % rad/s synchronous     JUP310
SEC.color       = [0.5,0.6,0.7];
SEC.img        = "europa.jpg";

SEC.mu          = SEC.gm / (SEC.gm + PRIM.gm);
mu              = SEC.mu;
e = SEC.ecc;
AU              = 149597927.000;                % km

BODY            = SEC;
EUROPA          = SEC;
JUPITER         = PRIM;

RUNIT           = SEC.sm;
TUNIT           = SEC.period / (2 * pi);
VUNIT           = RUNIT / TUNIT;
AUNIT           = RUNIT / TUNIT ^ 2;

if nargin == 0
    ln          = 0;
    rL          = [0;0;0];
else
    if ~(ln == 0||ln == 1||ln == 2||ln == 3||ln == 4||ln == 5)
        error('lagrange point muste be integer 0<=ln<=5')
    elseif ln == 0
        rL      = zeros(3,1);
    else
        [Xeq, ~]= CR3BPEqPts(mu);
        rL      = Xeq(1:3, ln);
    end
end

% assign global variables
LN              = ln;
RL              = rL;