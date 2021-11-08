function plt(rr,proj,c)
%function h=plt(rr,proj,c)
%  proj:1  xy
%       2  xz
%       3  yz
%       4  xyz
%	5  all

if nargin < 2
   proj=1;
   c='k';
elseif nargin < 3
   c='k';
end
if proj <= 1
   plot(rr(:,1),rr(:,2),c);
   xlabel('X');ylabel('Y');
elseif proj==2
   plot(rr(:,1),rr(:,3),c);
   xlabel('X');ylabel('Z');
elseif proj==3
   plot(rr(:,2),rr(:,3),c);
   xlabel('Y');ylabel('Z');
elseif proj==4
   plot3(rr(:,1),rr(:,2),rr(:,3),c);
   xlabel('X');ylabel('Y');zlabel('Z');axis('equal');
elseif proj==5
   h=zeros(1,4);
   subplot(2,2,1), plot(rr(:,1),rr(:,2),c);grid;axis('equal');
   xlabel('X');ylabel('Y');
   hold on;
   subplot(2,2,2), plot(rr(:,1),rr(:,3),c);grid;axis('equal');
   xlabel('X');ylabel('Z');
   hold on;
   subplot(2,2,3), plot(rr(:,2),rr(:,3),c);grid;axis('equal');
   xlabel('Y');ylabel('Z');
   hold on;
   subplot(2,2,4), plot3(rr(:,1),rr(:,2),rr(:,3),c);
   xlabel('X');ylabel('Y');zlabel('Z');axis('equal');
   hold on;
end
grid on;
axis('equal');