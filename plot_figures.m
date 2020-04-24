plot_dist(in_verts,simp,w,'none',0)
caxis([0,0.6])
set(gca,'fontsize',16);
saveas(gcf,strcat(files(filenum).name,'.fig'))
saveas(gcf,strcat(files(filenum).name,'.jpeg'))


plot_dist_error(in_verts,simp,wcovse)

plot_score(lambdas,scores)

% figure
% scatter(Q(:,1),Q(:,3),12,log10(I),'filled','square')
% caxis([-2,-1])
% colorbar
% figure
% scatter(Q(:,1),Q(:,2),12,log10(I),'filled','square')
% caxis([-2,-1])
% colorbar

%momoutput=[moments stdmoments];