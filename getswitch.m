function [idx,df,exact] = getswitch(xx,closed)
% function [idx,df,exact] = getswitch(xx,closed)
% 
% Find sign switches in an array of scalar values.
% 
% inputs:
% xx        :array of scalar values [Nx1] or [1xN]
% closed    :true/false indicator for closed curve
% 
% outputs:
% idx       :index array with sign switch locations [Mx1] or [1xM],
%            0<=M<N
% df        :offset values at switches [Mx1] or [1xM]
% exact     :index array for exact matches  [Px1] or [1xP], 0<=P<=M
% 
% LOG
% 01/29/2016
% Brian D. Anderson
%   Original Code.


% determine array dimensions
[ro,co] = size(xx);
col     = ro>co;

% switch to column array inside function
if ~col
    xx      = xx.';
    npts    = co;
else
    npts    = ro;
end

% generate sign arrays
if closed %for closed curves
    x1sign  = sign(xx);
    x2sign  = sign([xx(2:npts); xx(1)]);
else %for open curves
    x1sign  = sign(xx(1:npts - 1));
    x2sign  = sign(xx(2:npts    ));
end

% find changes in sign and offset
temp        = x2sign ~= x1sign;
idx         = find(temp);
df          = xx(idx);

% switch back to row array for output if necessary
if ~col
    idx     = idx.';
    df      = df.';
end

% find any exact zeros
exact       = find(df==0);
if ~isempty(exact)
    wmsg    = 'exact switches found';
    warning(wmsg)
    exact   = idx(exact);
end