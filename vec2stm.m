function [state,stm] = vec2stm(vec,N)

% function [state,stm] = vec2mat(vec,N)

% USE: Convert from vector to stm matrix for STM solver.

% IN   : vec = vector vec(N*N,1)

%          N     = ODE dimension – 4 or 6

%OUT: state = Nx1 vector of the state.

%          stm   = NxN matrix of the STM.

%NOTE: This is how I usually document my code, short and easy to read when you type “help ve2stm” in Matlab.

%            Note this is good for 4 or 6D equations.

N2 = N*N;

state = vec(N2+1:N2+N);

stm   = reshape(vec(1:N2),N,N);
