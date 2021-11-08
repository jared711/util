function [v_unit] = unit(v)
%UNIT returns a unit vector of the input vector
% 
% [v_unit] = UNIT(v)
% 
% Inputs:
%   v   [NX1] any vector
% 
% Outputs: 
%   v_unit  [NX1] unit vector
% 
% See also: 

v_unit = v/norm(v);

% Author: Jared Blanchard 	Date: 2020/08/18 17:08:32 	Revision: 0.1 $

end
