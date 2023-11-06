function savefigs(str)
%SAVEFIGS Save current figure as .fig, .jpg. and .eps file in the 'fig/'
%folder
str = strrep(str,'.','');
% save into it using pwd to get the full path:
saveas(gcf, pwd + "/fig/" + str +".jpg")
saveas(gcf, [pwd, '/fig/', str, '.eps'], 'epsc')
savefig(pwd + "/fig/" + str)
end