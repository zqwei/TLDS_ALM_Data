%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Similarity of PCA and LDA coefficient vectors as function of time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;

cmap                = cbrewer('div', 'Spectral', 128, 'cubic');
% cmap                = flipud(cmap);
% numFold             = 30;
% numRandPickUnits    = 100;
% numTrials           = numRandPickUnits*6;
% totTargets          = [true(numTrials/2,1); false(numTrials/2,1)];
ROCThres            = 0.5;


load([TempDatDir 'Shuffle_Spikes.mat'])    
% for nUnit                 = 1:length(nDataSet)
%     nDataSetOld(nUnit)    = rmfield(nDataSet(nUnit), {'depth_in_um', 'AP_in_um', 'ML_in_um', 'cell_type'});
% end

nDataSetOld               = nDataSet;

ActiveNeuronIndexOld      = ActiveNeuronIndex;
load([TempDatDir 'Shuffle_HiSpikes.mat'])  
nDataSet                  = [nDataSetOld; nDataSet];
ActiveNeuronIndex         = [ActiveNeuronIndexOld; ActiveNeuronIndex];
selectedNeuronalIndex = ActiveNeuronIndex';
selectedNeuronalIndex = selectedHighROCneurons(nDataSet, params, ROCThres, selectedNeuronalIndex);
nDataSet              = nDataSet(selectedNeuronalIndex);
numUnits              = length(nDataSet);
numT                  = length(params.timeSeries);



numFold             = 30;
corrMat             = nan(numFold, numT, numT);
numRandPickUnits    = numUnits;
numTrials           = numRandPickUnits*6;
totTargets          = [true(numTrials/2,1); false(numTrials/2,1)];

for nFold             = 1:numFold
    currRandPickUnits     = numRandPickUnits;
    nSessionData = shuffleSessionData(nDataSet(randperm(numUnits, currRandPickUnits)), totTargets, numTrials);
    nSessionData = normalizationDim(nSessionData, 2);
    coeffs       = coeffLDA(nSessionData, totTargets);
    corrMat(nFold, :, :) = coeffs'*coeffs;
end


figure;
hold on

imagesc(params.timeSeries, params.timeSeries, squeeze(mean(corrMat, 1)));
xlim([min(params.timeSeries) max(params.timeSeries)]);
ylim([min(params.timeSeries) max(params.timeSeries)]);
caxis([0 1]);
axis xy;
gridxy ([params.polein, params.poleout, 0],[params.polein, params.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
box off;
hold off;
xlabel('LDA Time (s)')
ylabel('LDA Time (s)')
colormap(cmap)
set(gca, 'TickDir', 'out')
setPrint(8, 6, 'Plots/SimilarityLDALDA_All')


% numRandPickUnits    = 400;
% numTrials           = numRandPickUnits*6;
% totTargets          = [true(numTrials/2,1); false(numTrials/2,1)];
% ROCThres            = 0.5;
% 
% 
% load([TempDatDir 'Shuffle_Spikes.mat']);
% selectedNeuronalIndex = ActiveNeuronIndex';
% selectedNeuronalIndex = selectedHighROCneurons(nDataSet, params, ROCThres, selectedNeuronalIndex);
% nDataSet              = nDataSet(selectedNeuronalIndex);
% numUnits              = length(nDataSet);
% numT                  = length(params.timeSeries);
% corrMat               = nan(numFold, numT, numT);
% 
% for nFold             = 1:numFold
%     currRandPickUnits     = numRandPickUnits;
%     nSessionData = shuffleSessionData(nDataSet(randperm(numUnits, currRandPickUnits)), totTargets, numTrials);
%     nSessionData = normalizationDim(nSessionData, 2);
%     coeffs       = coeffLDA(nSessionData, totTargets);
%     corrMat(nFold, :, :) = coeffs'*coeffs;
% end
% 
% 
% figure;
% hold on
% 
% imagesc(params.timeSeries, params.timeSeries, squeeze(mean(corrMat, 1)));
% xlim([min(params.timeSeries) max(params.timeSeries)]);
% ylim([min(params.timeSeries) max(params.timeSeries)]);
% caxis([0 1]);
% axis xy;
% gridxy ([params.polein, params.poleout, 0],[params.polein, params.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
% box off;
% hold off;
% xlabel('LDA Time (s)')
% ylabel('LDA Time (s)')
% colormap(cmap)
% set(gca, 'TickDir', 'out')
% setPrint(8, 6, 'Plots/SimilarityLDALDA_400')
% 
% setColorbar(cmap, 0, 1, 'similarity', 'Plots/SimilarityLDALDA')