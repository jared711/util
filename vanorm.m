function vnarr = vanorm(varr,roco)
% vnarr = vanorm(varr,roco)
% 
% Computes the array of vector norms corresponding to an array of vectors.
%
% inputs:
% varr      :array of vectors [Nxp] or [pxN]
% roco      :identifier for row vs. column vector array, 'row' or 'column'
% 
% outputs:
% vnarr     :array of vector norms [Nx1] or [1xN]
% 
% LOG
% 07/08/2015
% Brian D. Anderson   
%   Original Code.
% 
% Brian D. Anderson
% bdanders@usc.edu
% University of Southern California
% Los Angeles, CA


% switch statement for row vs. column vector array
switch roco
    case 'row'
        % initialize output array
        npts    = size(varr,1);
        vnarr   = zeros(npts,1);
        
        % compute the vector norm for each row
        for ro = 1:npts
            vnarr(ro) = (varr(ro,:) * varr(ro,:).') ^ 0.5;
        end
    case 'column'
        % initialize output array
        npts    = size(varr,2);
        vnarr   = zeros(1,npts);
        
        % compute the vector norm for each column
        for co = 1:npts
            vnarr(co) = (varr(:,co).' * varr(:,co)) ^ 0.5;
        end
end