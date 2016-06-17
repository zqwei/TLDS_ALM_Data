%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LDA across trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;
load([TempDatDir 'Shuffle_HiSpikes.mat']);


%% Single LDA of trial type across time
load([TempDatDir 'Shuffle_HiSpikes.mat']);
ROCThres            = 0.5;
selectedNeuronalIndex = ActiveNeuronIndex';
selectedNeuronalIndex = selectedHighROCneurons(nDataSet, params, ROCThres, selectedNeuronalIndex);
numFold             = 30;
numRandPickUnits    = sum(selectedNeuronalIndex);
numTrials           = numRandPickUnits*6;
totTargets          = [true(numTrials/2,1); false(numTrials/2,1)];

nDataSet            = nDataSet(selectedNeuronalIndex);
numUnits            = length(nDataSet);
numT                = length(params.timeSeries);
corrMat             = nan(numFold, numUnits);

for nFold             = 1:numFold
    nSessionData      = shuffleSessionData(nDataSet, totTargets, numTrials);
    nSessionData      = normalizationDim(nSessionData, 2);
    coeffs            = coeffTrialLDA(nSessionData, totTargets);
    corrMat(nFold, :) = coeffs;
end


%% LDA score traces
actMat              = nan(numUnits, numT*2);

for nUnit           = 1:numUnits
    actMat(nUnit, 1:numT)     = mean(nDataSet(nUnit).unit_yes_trial);
    actMat(nUnit, 1:numT)     = actMat(nUnit, 1:numT) - mean(actMat(nUnit, 1:8));
    actMat(nUnit, numT+1:end) = mean(nDataSet(nUnit).unit_no_trial);
    actMat(nUnit, numT+1:end)     = actMat(nUnit, numT+1:end) - mean(actMat(nUnit, numT+1:numT+8));
end



figure;
hold on
for nFold           = 1:numFold
    LDAscore            = corrMat(nFold, :) * actMat;
    plot(params.timeSeries, LDAscore(1:numT), '-r')
    plot(params.timeSeries, LDAscore(1+numT:end), '-b')
end
gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5)
hold off
box off
xlim([min(params.timeSeries) max(params.timeSeries)]);
xlabel('Time (s)')
ylabel('Trial-based LDA score (Hz)') 
setPrint(8, 6, 'Plots/CollectedUnitsTrialLDATrace')

% %% LDA coeffs distribution against group
% load('cellGroup.mat')
% logPValue  = getLogPValueTscoreSpikeEpoch(nDataSet, params);
% unitGroup  = plotTtestLogPSpikeEpoch (logPValue);
% groupIdx   = unitGroup;
% groupIdx(groupIdx<=7 & groupIdx>=1)  = 1;
% groupIdx(groupIdx<=14 & groupIdx>=8) = 2;
% groupIdx(groupIdx== 15)              = 3;
% 
% figure;
% hold on;
% xi              = -0.34:0.01:0.34;
% for nGroup = 0:3
%     corrs = corrMat(groupIdx==nGroup);
%     f = ksdensity(, xi);
%     plot(xi, f/max(f), '-', 'linewid', 1.0)
% end
% hold off
% box off
% xlim([-0.3 0.3]);
% xlabel(['PC' num2str(nPlot) ' Coeffs.'])
% ylabel('Normalized Prob. Density')  
% 
% setPrint(8*3, 6, 'Plots/CollectedUnitsPCACoeffsDynamicalNeuronNormalizedData')
% 
% 
% 
% %% LDA score traces against group