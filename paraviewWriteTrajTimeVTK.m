function [] = paraviewWriteTrajTimeVTK(rv0s, tspan, filename)
%PARAVIEWWRITETRAJTIMEVTK computes a set of initial conditions over the
%tspan and writes them to txt files that can be read as a group into
%Paraview
% 
% [] = PARAVIEWWRITETRAJTIMEVTK(rv0s, tspan, filename)
% 
% Inputs:   rv0s (6xm) [NON] initial conditions of trajectories
%           tspan (1xN) [NON] time vector
%           filename (string) [NON] prefix of filename
% 
% Outputs:  
% 
% See also: paraviewWriteTrajVTK

% Author: Jared Blanchard 	Date: 2023/08/02 11:38:53 	Revision: 0.1 $

[n,m] = size(rv0s);
if n ~= 6
    if m == 6
        rv0s = rv0s';
        [m,n]= deal(n,m);
    else
        error("rv0s must be 6xm")
    end     
end


for i = 1:m
        [tt,xx] = ode78(@(t,x) CR3BP(t, x), tspan, rv0s(:,i), eps);       

        for k = 1:N
            name = sprintf("%s_Fixdt_%05i.txt",filename,k-1);
            if ~isfile(name)
                fid = fopen(name, 'a' );
                fprintf( fid, '%s,%s,%s,%s,%s,%s,%s,%s\n', 'Idx', 'x', 'y', 'z', 'vx', 'vy', 'vz', 't');
                fprintf( fid, '%i,%f,%f,%f,%f,%f,%f,%f\n', i, xx(k,1), xx(k,2), xx(k,3), xx(k,4), xx(k,5), xx(k,6), tt(k));
            else
                fid = fopen(name, 'a' );
                fprintf( fid, '%i,%f,%f,%f,%f,%f,%f,%f\n', i, xx(k,1), xx(k,2), xx(k,3), xx(k,4), xx(k,5), xx(k,6), tt(k));
            end
            fclose(fid);
        end
        
end