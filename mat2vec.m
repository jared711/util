function [vec] = mat2vec(state,stm,N)

N2 = N*N;

vec = zeros(N2+N,1);

vec = reshape(stm,N2,1);

vec(N2+1:N2+N,1) = state;
