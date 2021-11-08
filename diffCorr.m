function [tt, xx, STM] = diffCorr(y0)
%Takes an initial condition y0 and attempts to change z and ydot to make it
%a periodic orbit.

%Create Event Function
comp = 2;                       %2 referring to 2nd component (y)
val = 0;                        %event occurs when comp = 0
DIR = -1;                       %must be coming from positive to negative
comp2 = 1;                      %1 referring to 1st component (x)
val2 = 1e12;                    %1e12 should never be reached by comp2
lessthan = 1;                   %evfcn triggered if comp2 is less than val2
evfcn = @(t,X) compval2(t,X,comp,val,DIR,comp2,val2,lessthan);
etol = 1e-13;                   %event function tolerance
tol = 1e-10;                    %Integration tolerance
trace = 0;                      %debugging trace


%differential corrector proper
for k = 1:100
    clear tt xx rv phi PHI
    y0 = [phi0;rv0];            %Initial state
    
    [tt, xx] = ode78ej(@(t,y) CR3BP_STM(t,y,mu), t0, tfinal, y0, tol, trace, evfcn, etol);
    ltt = length(tt);
    rv = xx(:,37:42);           %all integrated states
    lrv = length(rv);           
    phi = xx(:,1:36);           %all integrated flattened STMs
    
    %Plot half orbit
    plt4(rv, rvi, k)

    %Reshape STMs into 6x6 matrices
    PHI = zeros(6,6,length(rv));%all integrated square STMs
    for i = 1:length(rv)
        PHI(:,:,i) = reshape(phi(i,:),6,6);
    end
    PHI_T2 = PHI(:,:,end);
    
    rvT2 = rv(end,:);
    
    delxdot = -rvT2(4);
    delzdot = -rvT2(6);
    
    
    %Break before changing rv0
    if abs([delxdot; delzdot]) < tol
        [delxdot; delzdot];
        [VT2, DT2] = eig(PHI_T2);
        break
    end
    
    ydot = rvT2(5);

    PHI_partial = [PHI_T2(4,3),PHI_T2(4,5);
                   PHI_T2(6,3),PHI_T2(6,5)];
    
    state_dot = CR3BP_STM(0, [phi(end,:)'; rv(end,:)'], mu);
    xdoubledot = state_dot(40);
    zdoubledot = state_dot(42);
    dyad = [xdoubledot;zdoubledot]*[PHI_T2(2,3), PHI_T2(2,5)];
    
    delz_ydot = (PHI_partial-(1/ydot)*dyad)\[delxdot;delzdot];
    delz = delz_ydot(1);
    delydot = delz_ydot(2);
    
    rv0 = rv0 + [0;
                 0;
              delz;
                 0;
           delydot;
                 0];
end

end