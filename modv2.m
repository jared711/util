function xm = modv2(x,yl,yu)
% function xm = modv2(x,yl,yu)
% 
% modulus with chosen bounds.
% 
% inputs:
% x     :array to mod [NxM]
% yl    :lower bound [scalar]
% yu    :upper bound [scalar]
% 
% outputs:
% xm    :mod of x [NxM]
% Programmer: Brian.Danny.Anderson@gmail.com

% LOG
% ??/??/????, Brian D. Anderson
%   Original Code.


% shift values to start at zero
dy  = yu - yl;

% mod values to range and shift back to original location
xm  = mod(x-yl,dy) + yl;