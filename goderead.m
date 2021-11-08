function [xs,ts,idx,flag] = goderead(filename)
% function [xs,ts,idx,flag] = goderead(filename)
% 
% Read output file from gpu-ode integrator. Assumes single state for each
% particle, as in the case of a single event trigger or final-time-only
% integration.
% 
% assumes the input structure below:
% [index, flag, time, x, y, z, dx/dt, dy/dt, dz/dt]
% 
% inputs:
% filename  :string with filename to csv-formatted data [string]
% 
% outputs:
% xs        :particle state array [Nx6]
% ts        :particle time array [Nx1]
% idx       :particle index array [Nx1]
% flag      :particle success flag array [Nx1]
% 
% PROGRAMMER: Brian.Danny.Anderson@gmail.com

% LOG
% 02/20/2018, Brian D. Anderson
%   Original Code.

% read entire dataset from file
datf        = dlmread(filename,',');
datf(:,1)   = datf(:,1) + 1; %from zero based to 1 based index
npts        = size(datf,1);

% determine sorting based on index
idx         = datf(:,1);
[~,isort]   = sort(idx,'ascend');

% sort data and extract each subarray
datf        = datf(isort,:);
idx         = datf(:,1);
flag        = datf(:,2);
ts          = datf(:,3);
xs          = datf(:,4:9);