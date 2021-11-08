function [ttc,xxc,X0s,Ts,Cs,Mons,flags] = getorbC(Cdes,dataset)
% function [ttc,xxc,X0s,Ts,Cs,Mons,flags] = getorbC(Cdes,dataset)
% USE: Generate periodic orbit(s) with desired Jacobi constant from dataset
%      There can be multiple solutions in the cell arrays.
% IN : Cdes   :desired Jacobi constant [scalar] (non)
%      dataset:string indicating dataset to use
% OUT: ttc    :corresponding time output [Nx1] cell array
%      xxc    :converged state vector [Nx6] cell array
%      X0s    :converged initial state vector array [Mx6]
%      Ts     :converged orbit period array [Mx1]
%      Cs     :orbit Jacobi constant array [Mx1]
%      Mons   :Monodromy matrix arrayfor evaluating orbit stability [6x6xM]
%      flags  :boolean variable array indicating convergence [Mx1]
% 
% PROGRAMMER: Brian.Danny.Anderson@gmail.com

% LOG
% 09/20/2016, Brian D. Anderson   
%   Original Code.

load(dataset,'mu','X0arr','Tarr','Carr'); 
global mu
RelTol  = 5e-14;
AbsTol  = 1e-14;
DxTol   = 1e-12;
DzTol   = 1e-12;
DCTol   = 1e-14;
Lpt     = 1;
FRAC    = 2;
opts    = odeset('RelTol',RelTol,'AbsTol',AbsTol);

[x0,C0,idx0]    = mlinpol(X0arr,Carr,Cdes);
nsol            = length(idx0);
ttc             = cell(1,nsol);
xxc             = cell(1,nsol);
X0s             = zeros(nsol,6);
Ts              = zeros(nsol,1);
Cs              = zeros(nsol,1);
Mons            = zeros(6,6,nsol);
flags           = false(nsol,1);

if nsol > 1
    warning('multiple solutions found')
end
for sol = 1:nsol
    xi          = x0(sol,:);
    Ci          = C0(sol);
    idx         = idx0(sol);
    
    [~,xxi]     = ode113(@CR3BPbrian,[0 Tarr(idx)],xi.',opts);
    y0idx       = getswitch(xxi(:,2),false);
    Nint        = ceil((length(y0idx) - 1)/2);
    [xxi,tti,X0i,Ti,Ci,Moni,flagi] = CR3BPCorrC(Lpt,xi.',...
        Tarr(idx),Cdes,FRAC,Nint,0,RelTol,AbsTol,DxTol,DzTol,DCTol);
    ttc{sol}        = tti;
    xxc{sol}        = xxi;
    X0s(sol,:)      = X0i;
    Ts(sol,:)       = Ti;
    Cs(sol,:)       = Ci;
    Mons(:,:,sol)   = Moni;
    flags(sol,:)    = flagi;
end