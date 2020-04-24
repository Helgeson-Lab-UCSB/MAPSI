q = sqrt(Q(:,1).^2 + Q(:,2).^2 + Q(:,3).^2);
radialstep=0.001;
[A,idq] = histc(q,(min(q)):radialstep:(max(q)+radialstep));
radialq = accumarray(idq(:),q,[],@mean);
radialIntensity = accumarray(idq(:),I,[],@mean);
radialIntensitySTD = accumarray(idq(:),sigma,[],@mean)./sqrt(max(idq));
radialIntensity(radialq==0)=[];
radialIntensitySTD(radialq==0)=[];
radialq(radialq==0)=[];

%plotting radial average
figure(3)
hold on;
%scatter(radialq, radialIntensity)
errorbar(radialq,radialIntensity,radialIntensitySTD,'.');
set(gca,'xscale','log')
set(gca,'yscale','log')

RadialOutput=[radialq radialIntensity radialIntensitySTD];