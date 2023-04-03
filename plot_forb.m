function plot_forb(C, dim3, mu, conv, range, numpts)
%PLOT_FORB plots the forbidden region for a given Jacobi Constant
% 
% [] = PLOT_FORB(C, dim3, mu, conv, range, numpts)
% 
% Inputs:   C (scalar) [] Jacobi Constant
%           dim3 (boolean) Three-dimensional? {0}
%           mu (scalar) [] mass parameter {global mu}
%           conv (boolean) convention mu*(1-mu) {0}
%           range (1x4) [] range for plotting {[-1.5, 1.5, -1.5, 1.5]}
%           numpts (scalar) [] number of points to plot {3000}
%     
% Οutputs:
% 
% See also: PLOT_CR3BP, PLOT_PRIM, PLOT_SEC, PLOT_RV

% Author: Jared Blanchard 	Date: 2019/08/08 08:24:44 	Revision: 0.1 $ 
%                                                       Code copied from Travis
%                                                       Swenson's forbidden.m
% Author: Jared Blanchard 	Date: 2019/08/23 08:24:44 	Revision: 0.2 $
%                                                       Created own algorithm using
%                                                       augmented_potential.m
% Author: Jared Blanchard 	Date: 2019/08/23 08:24:44 	Revision: 0.3 $
%                                                       Updated Documentation

if nargin < 6;  numpts = 3000;                  end
if nargin < 5;  range = [-1.5, 1.5, -1.5, 1.5]; end
if nargin < 4;  conv = 0;                       end
if nargin < 3;  global mu;                      end
if nargin < 2;  dim3 = 0;                       end

E = -1/2*C;
if dim3
    numpts = 300;
    x = linspace(range(1),range(2),numpts);
    y = linspace(range(3),range(4),numpts);
    z = linspace(-0.1,0.1,numpts);
    [X,Y,Z] = meshgrid(x,y,z);
    U = augmented_potential(X,Y,Z, mu, conv);
    patch(isosurface(X,Y,Z,U,E),'FaceColor',[.8,.8,.8],'EdgeColor','none');
    axis([range, -0.1, 0.1])
    grid on
    camlight
    alpha(0.5)
else
    x = linspace(range(1),range(2),numpts);
    y = linspace(range(3),range(4),numpts);
    [X,Y] = meshgrid(x,y);
    U = augmented_potential(X,Y,zeros(size(X)),mu,conv);
    U = reshape(U,numpts,numpts);
%     contour(X,Y,U,[E,E])
    contourf(X,Y,U,[E,E],'FaceColor',[.8,.8,.8],'LineWidth',1 ,'HandleVisibility', 'off')
    axis equal
    grid on
end
end




