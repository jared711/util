function [RUNIT] = RUNIT_ER3BP(a,e,f)
%RUNIT_ER3BP Summary of this function goes here
% 
% [OUTPUTARGS] = RUNIT_ER3BP(INPUTARGS)
% 
% Inputs:   a [km] (scalar) semimajor axis of system
%           e [] (scalar) eccentricity of system
%           f [rad] (scalar) true anomaly of system
% 
% Outputs:  RUNIT [km] (scalar) normalizing distance for ER3BP
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/02/09 08:14:18 	Revision: 0.1 $

RUNIT = a*(1-e^2)/(1+e*cos(f));

end
