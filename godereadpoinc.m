function [xs,ts,idx,flag] = godereadpoinc(file_e,file_h)
% function [xs,ts,idx,flag] = godereadpoinc(file_e,file_h)
% 
% Read output file from gpu-ode poincare map integrator. Since
% indices are reset when passing output of pycuda-ode to pycuda-henon,
% this loads the output of the approximate integration to set 
% the particle indices back to the correct values.
% 
% assumes the input structure below:
% [index, flag, time, x, y, z, dx/dt, dy/dt, dz/dt]
% 
% inputs:
% file_e  	:filename to csv-formatted approximate event data [string]
% file_h  	:filename to csv-formatted henon step data [string]
% 
% outputs:
% xs        :particle state array [Nx6]
% ts        :particle time array [Nx1]
% idx       :particle index array [Nx1]
% flag      :particle success flag array [Nx1]
% 
% PROGRAMMER: Brian.Danny.Anderson@gmail.com

% LOG
% 06/03/2018, Brian D. Anderson
%   Original Code.


% read indices from approximate event
[~,~,idxe,~] 		= goderead(file_e);

% read henon step data, with wrong indices
[xs,ts,idx,flag] 	= goderead(file_h);

% set indices back to original values
idx 				= idxe(idx);
