subInit={'su','ef'};
load FoodStim
figure
%        Y = pdist(X,'cityblock');
for sub=1:length(subInit)
for ii=1:30;
    % matted=(squareform(squeeze((distMatsForAllTrials_ltv(1,:,ii)))));
    
    if exist(['./similarityJudgementData/' subInit{sub} '_session1_trial' num2str(ii) '.mat'])
        load(['./similarityJudgementData/' subInit{sub} '_session1_trial' num2str(ii) '.mat'])
    else
        break
    end
    if ii>2
        keep2(ii,:)=squeeze((distMatsForAllTrials_ltv(1,:,ii-1)));
    end
    matted=(squareform(estimate_dissimMat_ltv));
    keep(ii,:)=estimate_dissimMat_ltv;
    
    if ii>3
        costFunc(ii)= corr(keep(ii,:)',(keep(ii-1,:))');
        stopCostFunc(ii)=mean(costFunc(ii-3:ii));
        if stopCostFunc(ii)>.9995
            %        break
        end
    end
    myMinEvidenceWeight(ii)=min(evidenceWeight_ltv);
    vecDist=[];
    for i=1:size(matted,2)
        for j=i+1:size(matted,2)
            vecDist(end+1)=matted(i,j);
        end
    end
    Z = linkage(matted,'average');
    %        [H, T] = dendrogram(Z,'labels',{stimuli(T).name});
    
    [H, T,outperm] = dendrogram(Z,32,'labels',({stimuli.name}),'orientation','left');
    
    pause(.1)
end
x=corr(keep');
allMatted(sub,:,:)=matted;
end
%%

imagesc(squeeze(mean(allMatted)))
 Z = linkage(squeeze(mean(allMatted)),'average');
    %        [H, T] = dendrogram(Z,'labels',{stimuli(T).name});
    
    [H, T,outperm] = dendrogram(Z,32,'labels',({stimuli.name}),'orientation','left');
  
    foodMat=squeeze(mean(allMatted));
    foodNames={stimuli.name};
save myFoodMat foodMat foodNames

    
    %%
% % imagesc((elisamatted+silviamatted)/2)
%  Z = linkage(dissMat,'average');
%     %        [H, T] = dendrogram(Z,'labels',{stimuli(T).name});
%     
%     [H, T,outperm] = dendrogram(Z,32,'labels',({stimuli.name}),'orientation','left');
%   
%     