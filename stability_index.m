function idx = stability_index(PHI_T)
% idx = stability_index(PHI_T)

[n, m, p] = size(PHI_T);

assert(n == 6 && m == 6, "PHI_T is not 6x6")

real_eig = [];

for i = 1:p
    D = eig(PHI_T(:,:,i));
%     for j = 1:length(D)
%         if isreal(D(j)) && (D(j) > 1.0001 || D(j) < 0.9999)
%             real_eig = [real_eig, D(j)];
%         end
%     end
%     if length(real_eig) ~= 2
%         error('There are not two real eigenvalues')
%     else
%         idx(i,1) = 0.5*sum(real_eig);
%     end
    lambda = max(D);
    idx(i,1) = 0.5*(lambda + 1/lambda);
end
end

%Changelog
%Date           Programmer              Action
%07/23/2019     Jared T. Blanchard      Code written