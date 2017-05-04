function doStop=stopFunctionSLF(trial,subInit)
doStop=false;
for ii=1:trial;
% matted=(squareform(squeeze((distMatsForAllTrials_ltv(1,:,ii)))));

load(['./' subInit '_session1_trial' num2str(ii) '.mat']);
 keep(ii,:)=estimate_dissimMat_ltv;

if ii>3
   costFunc(ii)= corr(keep(ii,:)',(keep(ii-1,:))');
   stopCostFunc(ii)=mean(costFunc(ii-3:ii));
   if stopCostFunc(ii)>.9995
       doStop=true;
   end
end
end