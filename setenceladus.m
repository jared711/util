function setenceladus(ln)
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

global mu e BODY SATURN ENCELADUS SUN LN RL PRIM SEC AU RUNIT TUNIT VUNIT AUNIT

disp('Set SATURN-ENCELADUS System');
SUN.name        = 'SUN';
SUN.gm          = 132712440017.986999511718750000; % km^3/s^2
SUN.radius      = 6.955e5;                      % km (approximate value)

PRIM.name       = 'SATURN';
% PRIM.gm         = 37931208;                     % km^3/s^2  (+-1  )   http://ssd.jpl.nasa.gov/?gravity_fields_op
PRIM.gm         = 3.793120615901047E+07;        % km^3/s^2      ssd.jpl.nasa.gov/pub/eph/satellites/nio/LINUX_PC/sat427l.nio
% PRIM.gmbary     = 37940585;                     % km^3/s^2  (+-1  )   http://ssd.jpl.nasa.gov/?gravity_fields_op
PRIM.gmbary     = 3.794058484179918E+07;        % km^3/s^2  ssd.jpl.nasa.gov/pub/eph/satellites/nio/LINUX_PC/sat427l.nio
PRIM.radius     = 60268;                        % km        (+-4    )   http://ssd.jpl.nasa.gov/?planet_phys_par
PRIM.j2         = 16290.71e-6;                  % unitless  (+-0.27e-6) http://ssd.jpl.nasa.gov/?gravity_fields_op
% PRIM.j3         = 0;
PRIM.period     = 29.447498 * 365.25 * 86400;   % sec       (+-?    )   http://ssd.jpl.nasa.gov/?planet_phys_par
PRIM.sm         = ((SUN.gm + PRIM.gmbary) * (PRIM.period / (2 * pi)) ^ 2) ^ (1 / 3); % km
PRIM.rot        = 1 / 0.44401;                  % Rev/Day   (+-?    )   http://ssd.jpl.nasa.gov/?planet_phys_par
PRIM.rotD       = PRIM.rot * 360 / 86400;       % Deg/Sec   (+-?    )
PRIM.color      = [0.9294    0.6941    0.1255];
PRIM.img        = "saturn.jpg";

SEC.name        = 'ENCELADUS';
SEC.gm          = 7.2027;                       % km^3/s^2  (+-0.0125)  http://ssd.jpl.nasa.gov/?sat_phys_par
SEC.gm          = 7.210497553340731E+00;        % km^3/s^2  ftp://ssd.jpl.nasa.gov/pub/eph/satellites/nio/LINUX_PC/sat427l.nio
SEC.radius      = 252.10;                       % km        (+-0.10 )   http://ssd.jpl.nasa.gov/?sat_phys_par
SEC.sm          = 238042;                       % km        (+-?    )   http://ssd.jpl.nasa.gov/?sat_elem
SEC.ecc         = 0.0047;                       % This comes from Wikipedia %%%%%% unitless  (+-?    )   http://ssd.jpl.nasa.gov/?sat_elem
SEC.period      = 1.370 * 86400;                % sec       (+-?    )   http://ssd.jpl.nasa.gov/?sat_elem
SEC.rot         = 2 * pi / SEC.period;          % rad/s synchronous     JUP310
SEC.color       = [0.6 0.6 0.6];
SEC.img        = "enceladus_16k.jpg";

SEC.mu          = SEC.gm / (SEC.gm + PRIM.gm);
mu              = SEC.mu;
mu = 1.901109735892602e-7; % Number from Damon
e = SEC.ecc;
AU              = 149597927.000;                % km

BODY            = SEC;
ENCELADUS       = SEC;
SATURN          = PRIM;

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