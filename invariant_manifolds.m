function [stab_idx, PHI_T, Wsp, Wsn, Wup, Wun] = invariant_manifolds(rv0, T, tf, num_pts, man_plot, color)
% [stab_idx, PHI_T, Wsp, Wsn, Wup, Wun]  = invariant_manifolds(rv0, T, tf, num_pts, man_plot, color)
% Takes the initial conditions of a periodic orbit and calculates the
% invariant manifolds
% Inputs:
%     rv0 = [6x1] (double)   initial conditions of periodic orbit
%     T = (scalar)           Period of periodic orbit 
%     tf = (scalar)          Final time for manifold propagation {20}
%     num_pts = (scalar)     Number of points to perturb along periodic orbit
%                            Can be 'all' to perturb all points {30}
%     man_plot = [4x1] (int) determines which manifolds to plot
%                            [1,2,3,4] -> [Ws+, Ws-, Wu+, Wu-]
plot_on = 1;
if nargin < 6;          color = 'm';            end
if nargin < 5;          man_plot = [1,2,3,4];   end
if isempty(man_plot);   plot_on = 0;            end
if nargin < 4;          num_pts = 30;           end
if nargin < 3;          tf = 20;                end

if isstring(man_plot) || ischar(man_plot)
    if strcmp(man_plot,"stable");        man_plot = [1,2];   
    elseif strcmp(man_plot,"unstable");  man_plot = [3,4];
    else error("input must be 'stable' or 'unstable'"); end
end

% clear tt xx rv
global mu PRIM SEC RUNIT VUNIT TUNIT

C = jacobi_constant(rv0, mu);

phi0 = reshape(eye(6),36,1);
if ~iscolumn(rv0)
    y0 = [phi0; rv0'];
else
    y0 = [phi0; rv0];
end

[tt,xx] = ode78ej(@(t,y) CR3BP_STM(t,y,mu),0,T,y0,1e-12,0);
if isnumeric(num_pts)
    if size(xx,1) < num_pts
        tspan = linspace(0,T,num_pts);
        options = odeset('AbsTol',1e-12,'RelTol',1e-12);
        [tt,xx] = ode113(@(t,y) CR3BP_STM(t,y,mu),tspan,y0,options);
    end
end

rv = xx(:,37:42);           %all integrated states
lrv = length(rv);
phi = xx(:,1:36);
PHI_T = reshape(phi(end,:),6,6);

stab_idx = stability_index(PHI_T);

[VT, DT] = eig(PHI_T);

[idx_s, idx_u] = find_stable_eigs(diag(DT));
Yws = VT(:,idx_s); % stable direction
Ywu = VT(:,idx_u); % unstable direction

% real_idx = find(imag(diag(DT)) == 0);
% if length(real_idx) ~= 2
%     warning('There should be two real eigenvalues of the STM')
% end
% assert(length(real_idx) == 2,'There should be two real eigenvalues of the STM')
% 
% if (abs(DT(real_idx(1),real_idx(1))) < 1)
%     Yws = VT(:,real_idx(1)); % stable direction
%     %Yws = Yws/norm(Yws(1:3));
%     Ywu = VT(:,real_idx(2)); % unstable direction
%     %Ywu = Ywu/norm(Ywu(1:3));
% else
%     Yws = VT(:,real_idx(2)); % stable direction
%     %Yws = Yws/norm(Yws(1:3));
%     Ywu = VT(:,real_idx(1)); % unstable direction
%     %Ywu = Ywu/norm(Ywu(1:3));
% end



if plot_on
    myfig = gcf;
%     myfig = figure()
    hold on
    plot_sec
    plot_sphere(PRIM.radius/RUNIT, [-mu,0,0],myfig, 'b', 100)
    plot_rv(rv, 'k', 4, 4)
end

if num_pts == 'all'
    step = 1;
else
    step = ceil(lrv/num_pts);
end

Widx = 0;
for i = 1:step:lrv %rvi
    Widx = Widx + 1;    %manifold index
    
    PHI_t0t1 = reshape(phi(i,:),6,6);
    
    alpha = 1e-6;
    rv0sp = xx(i,37:42)' + alpha*PHI_t0t1*Yws/norm(PHI_t0t1*Yws); 
    rv0sn = xx(i,37:42)' - alpha*PHI_t0t1*Yws/norm(PHI_t0t1*Yws);
    rv0up = xx(i,37:42)' + alpha*PHI_t0t1*Ywu/norm(PHI_t0t1*Ywu);
    rv0un = xx(i,37:42)' - alpha*PHI_t0t1*Ywu/norm(PHI_t0t1*Ywu);
    %The norm(PHI_t0t1*Yws) is vital, otherwise you only follow one manifold 
    
    %Integrating time
    tfinalf = tf;
    tfinalb = -tfinalf;
    
    y0sp = [phi0;rv0sp];            %reset initial state
    y0sn = [phi0;rv0sn];
    y0up = [phi0;rv0up];
    y0un = [phi0;rv0un];
    
    tol = 1e-10;                    %Integration tolerance
    trace = 0;                      %debugging trace

%     [ttsp, xxsp] = ode78ej(@(t,y) CR3BP_STM(t,y,mu), 0, tfinalb, y0sp, tol, trace);
%     [ttsn, xxsn] = ode78ej(@(t,y) CR3BP_STM(t,y,mu), 0, tfinalb, y0sn, tol, trace);
%     
%     [ttup, xxup] = ode78ej(@(t,y) CR3BP_STM(t,y,mu), 0, tfinalf, y0up, tol, trace);
%     [ttun, xxun] = ode78ej(@(t,y) CR3BP_STM(t,y,mu), 0, tfinalf, y0un, tol, trace);
% 
%     Wsp{Widx} = [xxsp(:,37:42), ttsp];
%     Wsn{Widx} = [xxsn(:,37:42), ttsn];
%     Wup{Widx} = [xxup(:,37:42), ttup];
%     Wun{Widx} = [xxun(:,37:42), ttun];
    
%     if plot_on
%         plot_rv(xx(i,37:42),   'gx'); %starting point
%         for j = man_plot
%             if j == 1;  plot_rv(xxsp(:,37:42), 'b');    end %Stable should be cool colors
%             if j == 2;  plot_rv(xxsn(:,37:42), 'c');    end
%             if j == 3;  plot_rv(xxup(:,37:42), 'r');    end %Unstable should be hot colors
%             if j == 4;  plot_rv(xxun(:,37:42), 'm');    end
%         end
%     end

%     evfcn = @(t,X) ef_collideSec(t,X);

    if plot_on
        [ttsp, xxsp] = ode78e(@(t,y) CR3BPbrian(t,y), 0, tfinalb, rv0sp, tol, trace);%, evfcn);
        [ttsn, xxsn] = ode78e(@(t,y) CR3BPbrian(t,y), 0, tfinalb, rv0sn, tol, trace);%, evfcn);

        [ttup, xxup] = ode78e(@(t,y) CR3BPbrian(t,y), 0, tfinalf, rv0up, tol, trace);%, evfcn);
        [ttun, xxun] = ode78e(@(t,y) CR3BPbrian(t,y), 0, tfinalf, rv0un, tol, trace);%, evfcn);


        Wsp{Widx} = [xxsp, ttsp];
        Wsn{Widx} = [xxsn, ttsn];
        Wup{Widx} = [xxup, ttup];
        Wun{Widx} = [xxun, ttun];
    
        
        plot_rv(xx(i,37:42),   'kx',4,4); %starting point
        for j = man_plot
            if j == 1;  plot_rv(xxsp, 'b',4,4);    end %Stable should be cool colors
            if j == 2;  plot_rv(xxsn, 'c',4,4);    end
            if j == 3;  plot_rv(xxup, 'r',4,4);    end %Unstable should be hot colors
            if j == 4;  plot_rv(xxun, color,4,4);    end
        end
    else
        Wsp(Widx,:) = [rv0sp', tt(i)];
        Wsn(Widx,:) = [rv0sn', tt(i)];
        Wup(Widx,:) = [rv0up', tt(i)];
        Wun(Widx,:) = [rv0un', tt(i)];
    end
    
    %Plot manifolds
    

    
    
    %     europa_coords = [(1-mu);0;0];
    %     [idx(1,1,i), idx(1,2,i)] = find_min(xxsp, europa_coords);
    %     [idx(2,1,i), idx(2,2,i)] = find_min(xxsn, europa_coords);
    %     [idx(3,1,i), idx(3,2,i)] = find_min(xxup, europa_coords);
    %     [idx(4,1,i), idx(4,2,i)] = find_min(xxun, europa_coords);
    %
    %     idx1 = find((idx(:,2,i))*RUNIT< EUROPA.radius+2000);
    
%     clear xxsp xxsn xxup xxun
    
end

if plot_on
    manifolds = ["W^s^+", "W^s^-", "W^u^+", "W^u^-"];
    mylegend = ["Periodic Orbit","x_{\alpha}"];
    mylegend = [mylegend, manifolds(man_plot)];
    legend(mylegend)
    title({"Invariant Manifold Tubes","C = " + num2str(C), "i_s = " + num2str(stab_idx)})
    set(gcf, 'Position', get(0, 'Screensize'));
end


%Changelog
%Date           Programmer              Action
%08/07/2019     Jared T. Blanchard      Code written
%08/20/2019     Jared T. Blanchard      Added man capability to select
%                                       which manifolds to plot
%08/27/2019     Jared T. Blanchard      Added manifold outputs
