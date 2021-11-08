function PHIdot = STM(t,PHI)

global mu

if numel(PHI) == 20 % 2 Dimmensional
    PHI_mat = reshape(PHI(1:16),4,4);
    X = PHI(17:20);
    
    x = X(1);
    y = X(2);
    r = sqrt(x^2 + y^2);
    
    Xdot = [X(3);
        X(4);
        (-mu/(r^3))*x;
        (-mu/(r^3))*y];
    
    G = (mu/(r^5))*[3*x^2-r^2, 3*x*y;...
        3*y*x, 3*y^2-r^2];
    
    H = zeros(2);
    
    F = [zeros(2), eye(2);
        G, H];
    
    PHIdot_mat = F*PHI_mat;
    PHIdot = [reshape(PHIdot_mat,16,1);
        Xdot];
elseif numel(PHI) == 42 % 3 Dimensional
    
    PHI_mat = reshape(PHI(1:36),6,6);
    X = PHI(37:42);
    
    x = X(1);
    y = X(2);
    z = X(3);
    r = sqrt(x^2 + y^2 + z^2);
    
    Xdot = [X(4);
        X(5);
        X(6);
        (-mu/(r^3))*x;
        (-mu/(r^3))*y;
        (-mu/(r^3))*z];
    
    G = [(-mu/(r^3)),0,0;
        0,(-mu/(r^3)),0;
        0,0,(-mu/(r^3))];
    
%     G = (mu/(r^5))*[3*x^2-r^2, 3*x*y,3*x*z;...
%         3*y*x, 3*y^2-r^2, 3*y*z;...
%         3*z*x, 3*z*y, 3*z^2-r^2];
    
    H = zeros(3);
    
    F = [zeros(3), eye(3);
        G, H];
    
    PHIdot_mat = F*PHI_mat;
    PHIdot = [reshape(PHIdot_mat,36,1);
        Xdot];

end
end