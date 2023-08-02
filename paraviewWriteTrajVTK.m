function [] = paraviewWriteTrajVTK(xx, filename)
%PARAVIEWWRITETRAJVTK Writes a trajectory into a vtk file that can be read
%directly into paraview as a curve (no time dependence)
% 
% [] = PARAVIEWWRITETRAJVTK(xx, filename)
% 
% Inputs:   xx (N,6) [non] description 
%           filename (string) []
% 
% Outputs:  
% 
% See also: paraviewWriteTrajTimeVTK

% Author: Jared Blanchard 	Date: 2023/08/01 15:04:23 	Revision: 0.1 $

vtkwrite(filename,'structured_grid',xx(:,1),xx(:,2),xx(:,3),'vectors',...
    'velocity',xx(:,4),xx(:,5),xx(:,6))
    
end
