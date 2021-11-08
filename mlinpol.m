    function [x0,f0,idx] = mlinpol(xx,ff,fval)
% function [x0,f0,idx] = mlinpol(xx,ff,fval)
% 
% locates desired function values within a function/state pair mesh by
% linear interpolation. Finds the inputs x0 such that f(x0)=fval.

% inputs:
% xx        :array of vectors, independent variable [NxM]
% ff        :array of function values, [Nx1]
% fval      :desired value of function [scalar] {0}
% 
% outputs:
% x0        :linearly interpolated vectors [PxM]
% x0        :linearly interpolated function values [Px1]
% idx       :left indices for internally bracketed solutions [Px1]
% 
% PROGRAMMER: Brian.Danny.Anderson@gmail.com

% LOG
% 09/21/2016, Brian D. Anderson   
%   Original Code.

% set defaults
if nargin < 3;  fval    = 0;    end;

% determine system size
[npts,ndim]     = size(xx);

% find any internally bracketed solutions
ffrel   = ff - fval;
[idx]   = getswitch(ffrel,false);
nint    = length(idx);

% linear interpolation loop
if nint == 0 %examine mesh endpoints when no internal solutions found
    incr    = ffrel(2) - ffrel(1) > 0;  % slope of 1st segment
    over    = ffrel(1) > fval;          % 1st point over desired value?
    iis     = 1:2;
    
    if over == incr % if 1st segment points toward desired value
        x01     = linpol2(xx(iis,:),ff(iis),fval); %linear interp.
        f01     = fval;
        idx1    = 1;
    else % pointing away (empty output)
        x01     = [];
        f01     = [];
        idx1    = [];
    end
    
    incr    = ffrel(npts) - ffrel(npts - 1) > 0; % slope of last segment
    over    = ffrel(npts) > fval;       % last point over desired value?
    iis     = (npts - 1):npts;
    
    if over == ~incr  % if last segment points toward desired value
        x0f     = linpol2(xx(iis,:),ff(iis),fval); %linear interp.
        f0f     = fval;
        idxf    = npts;
    else % pointing away (empty output)
        x0f     = [];
        f0f     = [];
        idxf    = [];
    end
    
    % assemble output interpolated values
    x0      = [x01;x0f];
    f0      = [f01;f0f];
    idx     = [idx1;idxf];
else %examine internal solutions
    % initialize output arrays
    x0      = zeros(nint,ndim);
    f0      = ones(nint,1)*fval;
    for ii = 1:nint
        brk         = idx(ii) + (0:1); % indices for ith segment
        x0(ii,:)    = linpol2(xx(brk,:),ff(brk),fval); %linear interp.
    end
end