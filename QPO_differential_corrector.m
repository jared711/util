function [U, T, rho, err, dGdU] = QPO_differential_corrector(rv0, U0, T0, rho0, varargin)
%QPO_DIFFERENTIAL_CORRECTOR Differential corrector taking an initial guess of a QPO and
% correcting it until convergence. Following the work in Olikara, Scheeres
% (2012) Numerical method for computing quasi-periodic orbits and their
% stability in the restricted three-body problem, and McCarthy (2022)
% Cislunar trajectory design methodologies incorporating quasi-periodic 
% structures with applications
% 
% [U, T, rho, err, dGdU] = QPO_DIFFERENTIAL_CORRECTOR(rv0, U0, T0, rho0, varargin)
% 
% Inputs:   rv0 (nx1) initial state on the periodic orbit about which the invariant circle is centered
%           U0 (Nxn) [NON] initial guess of states on invariant circle (centered at the origin, make sure to add rv0 for integration)
%           T0 (scalar) [NON] initial guess for period
%           rho0 (scalar) [rad] ititial guess for rotation number
%           varargin
%               max_iter (int) [] maximum number of iterations {10}
%               epsilon (scalar) [] convergence criterion {1e-7}
%               plot_on (boolean) [] whether iterations should be plotted {0}
%               constraints (cell) [] constraints to be added {"x","y","z","xdot","zdot","T","rho","lambda"}
% 
% Outputs:  U (Nxn) [NON] final converged set of states on invariant circle 
%           T (scalar) [NON] final converged period
%           rho (scalar) [rad] final converged rotation number        
%           err (1xiter) [] norm of Newton steps to show convergence
%           dGdU (n*Nxn*N) [] discrete approximate of Floquet Matrix for G(U)
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/11/10 15:07:10 	Revision: 0.1 $
% Author: Jared Blanchard 	Date: 2023/04/21 16:44:19 	Revision: 0.2 $
global mu

p = inputParser;
addOptional(p,'max_iter', 10, @(x) validateattributes(x,"numeric","integer"))
addOptional(p,'epsilon', 1e-7, @isnumeric)
addOptional(p,'plot_on',false)
addOptional(p,'verbose',true)
addOptional(p,'constraints',["x","y","z","xdot","zdot","T","rho","lambda"], @isstring)
parse(p,varargin{:})
max_iter = p.Results.max_iter;
epsilon = p.Results.epsilon;
plot_on = p.Results.plot_on;
constraints = p.Results.constraints;
verbose = p.Results.verbose;

[N,n] = size(U0);
if n > N % make sure U0 is Nxn
    warning("n is larger than N. Taking transpose of U0 to make it an array of row vectors")
    U0 = U0';
    [N,n] = size(U0);
end
U = U0; % Initialize U, which is part of the vector that will be differentially corrected
T = T0; % Initialize T, which is part of the vector that will be differentially corrected
rho = rho0; % Initialize rho, which is part of the vector that will be differentially corrected

C0 = jacobi_constant(rv0, mu); % Jacobi constant of central orbit (desired Jacobi constant)
C = mean(jacobi_constants(rv0 + U0', mu)); % average Jacobi constant across invariant circle

[R, ~, ~, dRdrho, ~] = QPO_rotation_operator(rho, N); % get full rotation operator in real domain

err = zeros(1,max_iter); % error of each iteration
for iter = 1:max_iter
    % compute the stroboscopic map and rotate it back
    [F, PHI_tilde] = QPO_strob_map(rv0, U, T); % stroboscopic map
    G = R(rho)*F; % Stroboscobic map rotated back by rho

    % convert row-major matrices into long column vectors
    g_vec = reshape(G',n*N,1); % row major reshaping needs G' (Transpose)
    u_vec = reshape(U',n*N,1); % row major reshaping needs U' (Transpose)

    % compute error vector
    dgamma = [g_vec - u_vec; C-C0]; % error vector

    % could all be consolidated into one line if that's more elegant
%     dgamma = [reshape(G',n*N,1) - reshape(U',n*N,1); C - C0];

    % plot if plot_on flag is true
    if plot_on
        figure()
        plot_rv(U,'b.');
        plot_rv(U(1,:),'bx',4,2,'off');
        plot_rv(F,'r.');
        plot_rv(F(1,:),'rx',4,2,'off');
        plot_rv(G,'m.');
        plot_rv(G(1,:),'mx',4,2,'off');
        axis square
        title(sprintf("Iteration %i",iter))
        legend(sprintf("u_{%i}",iter-1),sprintf("F(u_{%i})",iter-1),sprintf("G(u_{%i})",iter-1))
    end

    % Compute the Jacobian
    % Starting iwth J₁ = ∂(G-U)/∂U
    % Compute the derivative of the integrated/rotated invariant circle with respect to the initial invariant circle (U) 
    % J₁ = ∂G_∂U - I,  We subtract the identity because ∂U/∂U = I
    dGdU = kron(R(rho), eye(6))*PHI_tilde; % approximation of floquet matrix
    
    % stop differential correction if error is small enough (we need to
    % compute dGdU first so it can be output
    err(iter) = norm(dgamma, "inf"); % norm of dgamma, could be 2-norm or inf-norm
    if verbose; fprintf("Iter: %i   Error: %e \n", iter, err(iter));   end

    if err(iter) < epsilon % must be smaller than epsilon
        if verbose; fprintf("Converged after %i iter \n", iter);    end
        break
    end
       
    J1 = dGdU - eye(n*N); % we subtract by I to include the ∂U/∂U = I term

    % Next J₂ = ∂G/∂T
    J2 = zeros(n*N,1);
    for i = 1:N
        idx = (i-1)*n + 1:i*n; % 1:n, n+1:n+6, ...
        J2(idx) = CR3BP(0, rv0 + G(i,:)', mu); % The derivative with respect to time comes right from the equations of motion
    end

    % Next J₃ = ∂uG/∂ρ
    J3 = dRdrho(rho)*F; % row-major matrix
    J3 = reshape(J3', n*N, 1); % make it a long column vector (from a row-major matrix)
    
    % Finally J₄ = ∂C/∂u
    J4 = zeros(1,n*N); % row vector of size n*N
    for i = 1:N
        idx = (i-1)*n + 1:i*n;
        rvdot = CR3BP(0, rv0 + U(i,:)', mu); % use U here instead of G
        xdot = rvdot(1); ydot = rvdot(2); zdot = rvdot(3);
        xddot = rvdot(4); yddot = rvdot(5); zddot = rvdot(6);
        Omega_x = xddot - 2*ydot;
        Omega_y = yddot + 2*xdot;
        Omega_z = zddot;
        J4(idx) = [2*Omega_x, 2*Omega_y, 2*Omega_z, -2*xdot, -2*ydot, -2*zdot]/N; % We divide by N because we want the derivative of C_avg with respect to u
    end

    % full Jacobian
    J = [J1, J2, J3;
         J4,  0,  0];
    
    for i = 1:length(constraints)
        constraint = zeros(1,size(J,2)); % constraint vector should fit on bottom of J
        switch constraints{i}
            case "x";       constraint(1) = 1;      constraint_error = 0;
            case "y";       constraint(2) = 1;      constraint_error = 0;
            case "z";       constraint(3) = 1;      constraint_error = 0;
            case "xdot";    constraint(4) = 1;      constraint_error = 0;
            case "ydot";    constraint(5) = 1;      constraint_error = 0;
            case "zdot";    constraint(6) = 1;      constraint_error = 0;
            case "T";       constraint(n*N+1) = 1;  constraint_error = 0;% index of dT variable
            case "rho";     constraint(n*N+2) = 1;  constraint_error = 0;% index of drho variable
%             case "lambda";  constraint_idx = lambda_idx;% index of drho variable
            case "C";       warning("C constraint not implemented yet"); continue;
            case "phase"
                [D, k, theta] = QPO_fourier_operator(N); % DFT matrix, indices k, and angles theta
                C0_tilde = D*U0;
                dU0dtheta1 = 1i*exp(1i*theta*k')*diag(k)*C0_tilde;
                if max(imag(dU0dtheta1)) > eps;  error("The derivative of the initial invariant circle with respect to θ₁ is complex");  end
                dU0dtheta1 = real(dU0dtheta1); % constrain to be real, just to get rid of the zero imaginary parts

                U0dot = zeros(N,n);
                for j = 1:N
                    U0dot(j,:) = CR3BP(0, rv0 + U0(j,:)', mu)';
                end
                dU0dtheta0 = T0/(2*pi)*(U0dot - rho0/T0*dU0dtheta1);

                dU0dtheta0 = reshape(dU0dtheta0',1,n*N); % convert to a row vector
                dU0dtheta1 = reshape(dU0dtheta1',1,n*N); % convert to a row vector

                constraint = [dU0dtheta0, 0, 0;
                              dU0dtheta1, 0, 0];

                constraint_error = [dU0dtheta0*u_vec; dU0dtheta1*u_vec];
                
            otherwise
                warning("Unknown Constraint, Adding nothing")
                constraint = [];
                constraint_error = [];
        end
        
        J = [J;constraint];
        dgamma = [dgamma;constraint_error]; % append a zero, or other constraint to the bottom of uG_error
   
    end
        
    dchi = -J\dgamma; % optimal change in initial conditions (should be rank deficient with constraint vectors included (rank should be nN+1)
        
    du = dchi(1:n*N);
    dT = dchi(n*N+1);
    drho = dchi(n*N+2);

    u_vec = u_vec + du;
    T = T + dT;
    rho = rho + drho;

    U = reshape(u_vec, n, N)';

    if plot_on
        plot_rv(U,'k.');
        plot_rv(U(1,:),'kx',4,2,'off');
        axis square
        legend(sprintf("u_{%i}",iter-1),sprintf("F(u_{%i})",iter-1),sprintf("G(u_{%i})",iter-1),sprintf("u_{%i}",iter))
    end


    if iter == max_iter
        fprintf("Didn't converge after %i iter \n", iter)
        break
    end
end

if plot_on
    figure()
    for i = 1:N
        [~,xx] = ode78e(@(t,x) CR3BP(t,x,mu), 0, T, U(i,:)'+rv0 ,1e-16);
        plot_rv(xx);
    end
end

end
