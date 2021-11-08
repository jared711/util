function [wx,idx,flag] = godereadtraj(filename)
% function [wx,idx,flag] = godereadtraj(filename)
% 
% Read output file from gpu-ode integrator. Handles multiple states for
% each particle.
% 
% assumes the input structure below:
% [index, flag, time, x, y, z, dx/dt, dy/dt, dz/dt]
% 
% inputs:
% filename  :string with filename to csv-formatted data [string]
% 
% outputs:
% wx        :particle state cell array {1xN}[Mx6]
% idx       :particle index array [Nx1]
% flag      :particle success flag array [Nx1]
% 
% PROGRAMMER: Brian.Danny.Anderson@gmail.com

% LOG
% 02/20/2018, Brian D. Anderson
%   Original Code.

% read entire dataset from file
dat         = dlmread(filename,',');
dat(:,1)    = dat(:,1) + 1; %from zero based to 1 based index
npts        = size(dat,1);

% get index and determine number of trajectories
datidx      = dat(:,1);
ntraj       = max(datidx);

% initialize output cells and arrays
wx          = cell(1,ntraj);
flag        = false(ntraj,1);
% idx         = zeros(ntraj,1);
idx         = (1:ntraj)';

% extract each particle trajectory
% parfor ii = 1:ntraj
for ii = 1:ntraj
    mski    = datidx==ii;
    wx{ii}  = [dat(mski,4:9),dat(mski,3)];
%     idx(ii) = ii;
    flags   = dat(mski,2);
    try
        flag(ii)= flags(end);
    catch
        flag(ii) = 0;
    end
end