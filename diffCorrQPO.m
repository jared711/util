function [u, rho, T, du_norm, G_x] = diffCorrQPO(u, rho, T, varargin)
% OUTDATED
% 
% DIFFCORRQPO Differential corrector taking an initial guess of a QPO and
% correcting it until convergence. Following the work in Olikara, Scheeres
% (2012) Numerical method for computing quasi-periodic orbits and their
% stability in the restricted three-body problem.
% 
% [u, rho, T, du_norm, G_x] = DIFFCORRQPO(u, rho, T, varargin)
% 
% Inputs:   u (6xN) [NON] initial guess of states on invariant circle 
%           rho (scalar) [rad] ititial guess for rotation number
%           T (scalar) [NON] initial guess for period
%           varargin
%               max_iter (int) [] maximum number of iterations {10}
%               epsilon (scalar) [] convergence criterion {1e-7}
%               plot_on (boolean) [] whether iterations should be plotted {0}
%               constraints (cell) [] constraints to be added {"x","y","z","xdot","zdot","T","rho","lambda"}
% 
% Outputs:  u (6xN) [NON] final converged set of states on invariant circle 
%           rho (scalar) [rad] final converged rotation number        
%           T (scalar) [NON] final converged period
%           du_norm (1xiter) [] norm of Newton steps to show convergence
%           G_x (n*Nxn*N) [] discrete approximate of Floquet Matrix for G(u)
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/11/10 15:07:10 	Revision: 0.1 $

p = inputParser;
addOptional(p,'max_iter', 10, @(x) validateattributes(x,"numeric","integer"))
addOptional(p,'epsilon', 1e-7, @isnumeric)
addOptional(p,'plot_on',false)
addOptional(p,'constraints',["x","y","z","xdot","zdot","T","rho","lambda"], @isstring)
parse(p,varargin{:})
max_iter = p.Results.max_iter;
epsilon = p.Results.epsilon;
plot_on = p.Results.plot_on;
constraints = p.Results.constraints;

[n,N] = size(u);
if n > N
    warning("n is larger than N. Make sure u is an array of column vectors")
end

T_idx = n*N + 1; % index of T variable
rho_idx = T_idx + 1; % index of rho variable
lambda_idx = rho_idx + 1; % index of lambda variable


[D, Dinv, dDinvdtheta] = matFourier(N, n);

du_norm = zeros(1,max_iter);
for iter = 1:max_iter
    u_vec = reshape(u,n*N,1);

    Q = rotFourier(-rho, N, n); % make sure to use -rho here
    R = real(Dinv*Q*D); % rotation operator (eq. 17)

    F = strob_map(u,T);
    F_vec = reshape(F,n*N,1);

    G_vec = R*F_vec; % Stroboscopic map with rotation
    G = reshape(G_vec,n,N);

    if plot_on
        figure()
        plot_rv(u,'b.');
        plot_rv(u(:,1),'bx',4,2,'off');
        plot_rv(F,'r.');
        plot_rv(F(:,1),'rx',4,2,'off');
        plot_rv(G,'m.');
        plot_rv(G(:,1),'mx',4,2,'off');
        title(sprintf("Iteration %i",iter))
        legend(sprintf("u_{%i}",iter-1),sprintf("F(u_{%i})",iter-1),sprintf("G(u_{%i})",iter-1))
    end

    F_x = jac_x(u,T);
    F_theta = jac_theta(dDinvdtheta, D, F_vec);
    F_rho = zeros(size(F_theta));
    F_lambda = zeros(n*N,1);
    F_T = jac_T(u,T);

    M = R*[F_x,F_T,F_rho-F_theta,F_lambda] - [eye(n*N), zeros(size(F_T)), zeros(size(F_theta)), zeros(size(F_lambda))];
    uG_error = u_vec - G_vec;

    for i = 1:length(constraints)
        switch constraints{i}
            case "x";       constraint_idx = 1;
            case "y";       constraint_idx = 2;
            case "z";       constraint_idx = 3;
            case "xdot";    constraint_idx = 4;
            case "ydot";    constraint_idx = 5;
            case "zdot";    constraint_idx = 6;
            case "T";       constraint_idx = T_idx;% index of dT variable
            case "rho";     constraint_idx = rho_idx;% index of drho variable
            case "lambda";  constraint_idx = lambda_idx;% index of drho variable
            case "C";       warning("C constraint not implemented yet"); continue;
            case "phase";   warning("phase constraint not implemented yet"); continue;
            otherwise
                if isnumeric(constraints{i})
                    constraint_idx = constraints{i};    
                else
                    warning("Unknown Constraint Added")
                end
        end
        [M, uG_error] = add_constraint(M, uG_error, constraint_idx);    
    end
        
    dvec = M\uG_error; % TODO make sure this shouldn't be u_hat_v - G (eq. 18)
        
    du = dvec(1:n*N);
    du_norm(iter) = norm(du);
    dT = dvec(T_idx);
    drho = dvec(rho_idx);
    dlambda = dvec(lambda_idx);

    u_vec = u_vec + du;
    T = T + dT;
    rho = rho + drho;

    u = reshape(u_vec, n, N);

    if plot_on
        plot_rv(u,'k.');
        plot_rv(u(:,1),'kx',4,2,'off');
        legend(sprintf("u_{%i}",iter-1),sprintf("F(u_{%i})",iter-1),sprintf("G(u_{%i})",iter-1),sprintf("u_{%i}",iter))
    end

    if abs(du) < epsilon
        fprintf("Converged after %i iter \n", iter)
        break
    end
    if iter == max_iter
        fprintf("Didn't converge after %i iter \n", iter)
        break
    end
end

if plot_on
    figure()
    for i = 1:length(u)
        [~,xx] = ode78e(@(t,x) CR3BP(t,x), 0, T, u(:,i) ,1e-16);
        plot_rv(xx);
    end
end

du_norm = du_norm(du_norm~=0); % cut off trailing zeros
G_x = R*F_x;
end
