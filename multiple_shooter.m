function [s] = multiple_shooter(rv0, T, N)
%MULTIPLE_SHOOTER Differential corrector using multiple segments of a
%trajectory. 
% 
% [s] = MULTIPLE_SHOOTER(rv0, T, N)
% 
% Inputs: 
% 
% Outputs: 
% 
% See also: 

% Author: Jared Blanchard 	Date: 2022/08/29 11:42:17 	Revision: 0.1 $

num_iter = 20;
tol = 1e-6;

if ~iscolumn(rv0);  warning('rv0 should be a 6x1 column vector');   end

T_i = T/N;

if length(rv0) > 6
    s = rv0;
    n = 6;
else

    xi_pos = rv0;
    xi_neg = rv0;

    n = length(rv0);

    % 8/30/22 Note, I'm giving this multiple shooter just an initial condition.
    % This probably won't work well. It would probably work better with a whole
    % set of states at each point i that aren't dynamically connected. As it is
    % now, the constraint x(x_N-1, T_N-1) - x_0 = 0 is going to be the only one
    % that isn't met, and it will be huge.

    % make the huge initial state vector
    % s = zeros(6*N+1, 1);
    s = zeros(6*N, 1); % fixing the period
    for i = 1:N/2
        idx1 = 6*i-5;   % n*(i-1) + 1
        idx2 = 6*i;     % n*i
        s(idx1:idx2) = xi_pos;

        % integrate forward
        [~,xx] = ode78e(@(t,x) CR3BP(t,x), 0, T_i, xi_pos, 1e-12);
        xi_pos = xx(end,:)';

        idx3 = 6*N+1-n*i;
        idx4 = 6*N+1-n*i+5;
        [~,xx] = ode78e(@(t,x) CR3BP(t,x), 0, -T_i, xi_neg, 1e-12);
        xi_neg = xx(end,:);           % integrated state
        s(idx3:idx4) = xi_neg';
    end
    % s(end) = T;
    % s = s + 1e-6*randn(size(s));

end

% A = zeros(6*N, 6*N+1);
A = zeros(6*N, 6*N); % fixing the period
c = zeros(6*N, 1);
PHI_0 = eye(6);
PHI_0_vec = reshape(PHI_0,36,1);

for iter = 1:num_iter
%     T_i = s(end)/N;
    figure()

    for i = 1:N
        idx1 = 6*i-5;   % n*(i-1) + 1
        idx2 = 6*i;     % n*i
        idx3 = 6*i+1;   % n*i + 1
        idx4 = 6*i+6;   % n*(i+1)

        y0 = [PHI_0_vec; s(idx1:idx2)];
        [~,xx] = ode78e(@(t,x) CR3BP_STM(t,x), 0, T_i, y0, 1e-12);
        plot_rv(xx)
        xi = xx(end,37:42)';           % integrated state
        phi_vec = xx(end,1:36);
        PHI_Ti = reshape(phi_vec,6,6); % integrated STM
    %     T_i = tt(end);
        x_dot_i = CR3BP(0,xi);

        A(idx1:idx2, idx1:idx2) = PHI_Ti;

%         A(idx1:idx2, end) = x_dot_i; % fixing the period
        if i < N
            A(idx1:idx2, idx3:idx4) = -eye(n);
            c(idx1:idx2) = xi - s(idx3:idx4);
        else
            A(idx1:idx2, 1:6) = -eye(n);
            c(idx1:idx2) = xi - s(1:6);
        end
    end
    title(sprintf('iteration %i',iter))
    delta_s = -A\c;

    if abs(delta_s) < tol
        fprintf("converged after %i iterations\n",iter)
        break
    end
    
    s = s + delta_s;
end

if ~(abs(delta_s) < tol)
    warning("didn't converge")
end
    

end

