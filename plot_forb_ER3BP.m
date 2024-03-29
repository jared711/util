function plot_forb_ER3BP(C, e, f, dim3, mu, conv, range, numpts)
% plot_forb(C, dim3, mu, conv, range, numpts)
% Inputs:
%     C = (scalar) Jacobi Constant
%     e = (scalar) eccentricity of primary/secondary orbits
%     f = (scalar) true anomaly of secondary about primary
%     dim3 = (boolean) Three-dimensional?
%     conv = (boolean) convention
%             if 1 
%     

if nargin < 8;  numpts = 3000;                  end
if nargin < 7;  range = [-1.5, 1.5, -1.5, 1.5]; end
if nargin < 6;  conv = 0;                       end
if nargin < 5;  global mu;                      end
if nargin < 4;  dim3 = 0;                       end
if nargin < 3;  f = 0;                          end
if nargin < 2;  e = 0;                          end
% 
% syms nu
% omega_f = e*sin(nu)/(1+e*cos(nu))^2;
% int_term = int(omega_f,nu,0,f);
int_term = 0;

E = -1/2*(C+int_term)*(1+e*cos(f));
if dim3
    numpts = 300;
    x = linspace(range(1),range(2),numpts);
    y = linspace(range(3),range(4),numpts);
    z = linspace(-1,1,numpts);
    [X,Y,Z] = meshgrid(x,y,z);
    U = augmented_potential(X,Y,Z, mu, conv);
    patch(isosurface(X,Y,Z,U,E),'FaceColor',[.8,.8,.8],'EdgeColor','none');
    axis equal
    grid on
    camlight
    alpha(0.5)
else
    x = linspace(range(1),range(2),numpts);
    y = linspace(range(3),range(4),numpts);
    [X,Y] = meshgrid(x,y);
    U = augmented_potential(X,Y,zeros(size(X)),mu,conv);
    U = reshape(U,numpts,numpts);
    contourf(X,Y,U,[E,E],'FaceColor',[.8,.8,.8],'LineWidth',1 ,'HandleVisibility', 'off')
    axis equal
    grid on
end
end


%Changelog
%Date               Programmer              Action
%08/08/2019         Jared T. Blanchard      Code copied from Travis
%                                           Swenson's forbidden.m
%08/23/2019         Jared T. Blanchard      Created own algorithm using
%                                           augmented_potential.m

