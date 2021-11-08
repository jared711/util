function godeinit(x0,t0,tf,tol,mu,fname_state,fname_param)
% function godeinit(x0,t0,tf,tol,mu,fname_state,fname_param)
% 
% Make two files with initial state and integration parameters for use with
% gpu-ode integrator.
% 
% assumes the input structure below:
% [index, flag, time, x, y, z, dx/dt, dy/dt, dz/dt]
% 
% inputs:
% x0            :particle state array [Nx6]
% t0            :initial time [scalar]
% tf            :final time [scalar]
% tol           :integrator tolerance (absolute) [scalar]
% mu            :particle state array [Nx6]
% fname_state   :filename for csv-formatted state {'init_state.csv'}
% fname_param   :filename for csv-formatted parameters {'init_param.csv'}
% 
% outputs:
% N/A
% 
% PROGRAMMER: Brian.Danny.Anderson@gmail.com
%
% The state array is written as ASCII double text (%.15e):
% [x1,...,xn;
%  y1,...,yn;
%  z1,...,zn;
%  dx1,...,dxn;
%  dy1,...,dyn;
%  dz1,...,dzn]
% size 22*6*n = 132*n bytes 
%
% The parameter array is written as ASCII double text (%.15e):
% [t0,tf,tol,mu]
% size 22*4 = 88 bytes
%
% total file size approx 132*n bytes

% LOG
% 02/20/2018, Brian D. Anderson
%   Original Code.

% set defaults
if nargin<7;    fname_param     = 'init_param.csv'; end
if nargin<6;    fname_state     = 'init_state.csv'; end

% print error on wrong input shape
nd      = size(x0,2);
if nd~=6
    error('input state must be Nx6')
end

% get number of points from data
n       = size(x0,1);
fsize   = 132*n + 88; %bytes
fMB     = fsize/1024^2;
fGB     = fMB/1024;

tic
% write state file
dlmwrite(fname_state,x0.','precision','%.15e');

% write parameter file
dlmwrite(fname_param,[t0,tf,tol,mu],'precision','%.15e');

% print time to write
fprintf('write time = %.2f s\n',toc)
fprintf('total file size = %.3f MB = %.1f GB\n',fMB,fGB)
