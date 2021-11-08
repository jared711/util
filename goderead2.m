function [xs,ts,idx,flag] = goderead2(filename,nline)
% function [xs,ts,idx,flag] = goderead2(filename,nline)
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
% nline		:number of lines to read [scalar] {all}
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
fid 		= fopen(filename,'r');
if nargin < 2
	dat		= textscan(fid,'%d,%d,%f,%f,%f,%f,%f,%f,%f');
else
	dat		= textscan(fid,'%d,%d,%f,%f,%f,%f,%f,%f,%f',nline);
end
datd 		= cell2mat(dat(1:2));
datf 		= cell2mat(dat(3:9));
npts        = size(datf,1);

% shift index to 1-based
datd(:,1)   = datd(:,1) + 1;

% determine sorting based on index
idx         = datd(:,1);
[~,isort]   = sort(idx,'ascend');

% sort data and extract each subarray
datf        = datf(isort,:);
datd        = datd(isort,:);
idx         = datd(:,1);
flag        = logical(datd(:,2));
ts          = datf(:,1);
xs          = datf(:,2:7);
