function [options] = ephemOptions()
%EPHEMOPTIONS creates an options structure for ephemeris integration with
%default values
% 
% [options] = EPHEMOPTIONS()
% 
% Inputs: 
% 
% Outputs: 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/08/01 16:30:16 	Revision: 0.1 $

options.et0 = cspice_str2et(date); % et0 is the current date
options.frame = 'ECLIPJ2000';
options.observer = 'Earth';
options.bodies = {'Earth'};

end