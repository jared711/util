function setneptune(ln)
% setneptune(ln)
% 
% ln defines the lagrange point number as origin, ln=0 sets origin as CR3BP
% origin (system barycenter). ln=0 is the default if none is specified.
% 
% Solar System Model from ???
% 
% Record of Revision
% Date          Programmer          Description of Changes
% 07/15/2019    Jared T. Blanchard  Copied from Brian D. Anderson's
%                                   setjupiter.m from 07/01/2013                 

global mu BODY NEPTUNE SUN LN RL PRIM SEC AU RUNIT TUNIT VUNIT AUNIT

disp('Set SUN-Neptune System');
SUN.name        = 'SUN';
SUN.gm          = 132712440017.986999511718750000;      % km^3/s^2
SUN.radius      = 6.955e5;                              % km (approximate value)

NEPTUNE.name    = 'NEPTUNE';
NEPTUNE.gm      = 6835100;    %%                       % km^3/s^2  (+-10    )   http://ssd.jpl.nasa.gov/?gravity_fields_op
NEPTUNE.gmbary  = 6836527;    %%                     % km^3/s^2  (+-10    )   http://ssd.jpl.nasa.gov/?gravity_fields_op
NEPTUNE.mu      = NEPTUNE.gm / (SUN.gm + NEPTUNE.gm); %%  % unitless
NEPTUNE.mubary  = NEPTUNE.gmbary / ...
    (NEPTUNE.gmbary + SUN.gm);       %%                   % unitless
NEPTUNE.period  = 60190.02963 * 86400;     %%                % sec       (+-?    )
NEPTUNE.sm      = ((SUN.gm + NEPTUNE.gmbary) * ...
    (NEPTUNE.period / (2 * pi)) ^ 2) ^ (1 / 3);  %%       % km    (+-?    )
NEPTUNE.e       = 0.00895439;  %%                         % unitless  (+-?    )   JPL SSD http://ssd.jpl.nasa.gov/?planet_pos (3000 BC-3000 AD, J2000) 
mu              = NEPTUNE.mubary; %%
NEPTUNE.radius  = 24764;   %%                             % km        (+-4    )   http://ssd.jpl.nasa.gov/?planet_phys_par
NEPTUNE.j2      = 3408.43e-6; %%                          % unitless  (+-4.50e-6) http://ssd.jpl.nasa.gov/?gravity_fields_op
NEPTUNE.j4      = -33.40e-6;    %?????                         % unitless  (+-2.90e-6) http://ssd.jpl.nasa.gov/?gravity_fields_op
NEPTUNE.flat    = 0.06487;                              % unitless  (+-?    )
NEPTUNE.rot     = 1 / 0.67125;   %%                       % Rev/Day   (+-?    )
NEPTUNE.rotD    = NEPTUNE.rot * 360 / 86400;            % Deg/Sec   (+-?    )
NEPTUNE.rotR    = deg2rad(NEPTUNE.rotD);   %%                        % Rad/Sec   (+-?    )

AU              = 149597927.000;                        % km

BODY         = NEPTUNE;
SEC          = NEPTUNE;
PRIM         = SUN;

[RUNIT TUNIT VUNIT AUNIT] = setunits(BODY);

if nargin==0
    ln       = 0;
    rL       = [0;0;0];
else
    if ~(ln==0||ln==1||ln==2||ln==3||ln==4||ln==5)
        error('lagrange point muste be integer 0<=ln<=5')
    elseif ln==0
        rL   = zeros(3,1);
    else
        [Xeq, ~]     = CR3BPEqPts(mu);
        rL           = Xeq(1:3,ln);
    end
end

% assign global variables
LN       = ln;
RL       = rL;