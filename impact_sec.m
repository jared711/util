function [rvi] = impact_sec(rv, Rsec)
% function [rvi, t] = impact_sec(rv, t)
% Inputs:
%     rv [6xN]
global mu SEC RUNIT
if nargin < 2;  Rsec = SEC.radius/RUNIT;    end

[n,m] = size(rv);
if n ~= 6
    if m~=6
        error('wrong dimensions, should be 6xN');
    else
        rv = rv';
    end
end

sec = [1-mu;0;0];
r = rv(1:3,:) - sec;
r_norm = zeros(1,length(r));
for i = 1:length(r)
    r_norm(i) = norm(r(:,i));
end
impact_idx = find(r_norm<Rsec,1);
rvi = rv(:,impact_idx);
end

%Changelog
%Date           Programmer              Action
%08/27/2019     Jared T. Blanchard      File created
