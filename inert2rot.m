function rv_rot = inert2rot(rv_inert, t, origin, mu)
% rv_rot = rot2inert(rv_inert, t, origin)
% Inputs:
%     rv_inert = [6xN] state vectors [rv1, rv2, rv3] in inertial frame
%     t = [1xN] non-dimensional time
%     origin = (string) 'BARY', 'PRIM', 'SEC' origin of inertial frame
% Outputs
%     rv_rot = [6xN] state vectors [rv1, rv2, rv3] in rotating frame

[n,m] = size(rv_inert);
if n ~= 6
    if m == 6
        rv_inert = rv_inert';
        m = n;
    else
        error("rv_inert should be 6xN")
    end
end

if nargin < 4;      global mu;          end
if isempty(mu);     mu = 3.0404233e-06; end
if nargin < 3;      origin = 'BARY';    end
if nargin < 2;      t = 0;              end

if length(t) == 1
    t = t*ones(1,m);
elseif iscolumn(t)
    t = t';
end

rv_rot = zeros(6,m);
for i = 1:m
    if upper(origin) == "BARY"
    elseif upper(origin) == "PRIM"
        r_offset  = -mu*[cos(t(i)); sin(t(i)); 0];
        v_offset  = -mu*[-sin(t(i)); cos(t(i)); 0];
        rv_offset = [r_offset; v_offset];
        rv_inert(:,i) = rv_inert(:,i)+rv_offset;
    elseif upper(origin) == "SEC"
        r_offset  = (1-mu)*[cos(t(i)); sin(t(i)); 0];
        v_offset  = (1-mu)*[-sin(t(i)); cos(t(i)); 0];
        rv_offset = [r_offset; v_offset];
        rv_inert(:,i) = rv_inert(:,i)+rv_offset;
    else
        error('origin must be BARY, PRIM, or SEC')
    end
    
    A = [ cos(t(i)), sin(t(i)), 0;
        -sin(t(i)), cos(t(i)), 0;
        0,         0, 1];
    
    O = zeros(3);
    
    B = [-sin(t(i)),  cos(t(i)), 0;
        -cos(t(i)), -sin(t(i)), 0;
        0,          0, 0];
    
    C = [A, O; B, A];
    
    rv_rot(:,i) = C * rv_inert(:,i);
end

%Changelog
%Date           Programmer              Action
%08/12/2019     Jared T. Blanchard      File created
%08/13/2019     Jared T. Blanchard      Added origin offset
%08/14/2019     Jared T. Blanchard      Generalized for multiple vectors