function pngsave(hfig,filename,pxsize,dpi)
% function pngsave(hfig,filename,pxsize,dpi)
% 
% save a png of given plot. Saves png as current screen size and
% resolution if no size given. You can use this to save a figure to a 
% desired resolution without manually resizing the figure window if you
% specify a size and optionally DPI. DPI won't change the pixel size, but
% some elements will change size with different DPI settings, such as text.
% For very small resolution images, it's a good idea to reduce the DPI so
% that text scales down with the figure.
% 
% inputs:
% hfig      :figure handle
% filename  :desired filename without extension [string]
% pxsize    :(optional) desired size in pixels [xsize,ysize] [1x2]
% dpi       :(optional) desired DPU [integer] {300}
%
% outputs:
% N/A
% 
% Programmer: Brian D. Anderson

% LOG
% 01/20/2017, Brian D. Anderson
%   Original Code.
% 09/28/2018, Brian D. Anderson
%   Added size input for printing without manually resizing figure window.


% set default dpi
if nargin < 4;  dpi     = 300;  end

% use screen paper position and resolution if no pixel size given,
% otherwise set the size of the paper.
if nargin < 3
    set(hfig,'PaperPositionMode','auto')
    dpi     = 0;
else
    set(hfig,'PaperPosition',[0,0,pxsize]/dpi)
end

% print figure to file
dpistr  = ['-r',num2str(dpi,'%d')];
print(hfig,filename,'-dpng',dpistr)