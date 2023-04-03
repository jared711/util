function [h] = plot_quiver(rv)
%PLOT_QUIVER plots state vector(s) as a quiver, velocity emanating from
%position
% 
% [] = PLOT_QUIVER(rv)
% 
% Inputs: 
%           rv (6xN OR 4xN) [] state vector [r;v]
% 
% Outputs: 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2021/10/27 09:21:33 	Revision: 0.1 $

[m,n] = size(rv);
if m == 4 || m == 6
    if n == 4 || n == 6
        warning('dimensions ambiguous, rv should be (6xN or 4xN)')
    end
else
    if n == 4 || n == 6
        rv = rv';
        m = n;
    else
        error('rv should be (6xN or 4xN)')
    end
end

if m == 4
    h = quiver(rv(1,:),rv(2,:),rv(3,:),rv(4,:));
elseif m == 6
    h = quiver3(rv(1,:),rv(2,:),rv(3,:),rv(4,:),rv(5,:),rv(6,:));
end

end
