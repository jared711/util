function savefigs(str)
%SAVEFIGS Save current figiure as .fig, .jpg. and .eps file in the 'fig/'
%folder

% save into it using pwd to get the full path:
saveas(gcf, pwd + "/fig/" + str +".jpg")
% saveas(gcf, [pwd, '/fig/', str, '.eps'], 'epsc')
savefig(pwd + "/fig/" + str)
end