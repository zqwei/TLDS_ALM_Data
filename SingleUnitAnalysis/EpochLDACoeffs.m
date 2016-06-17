%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LDA across epochs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;
load([TempDatDir 'Shuffle_Spikes.mat'])    
for nUnit                 = 1:length(nDataSet)
    nDataSetOld(nUnit)    = rmfield(nDataSet(nUnit), {'depth_in_um', 'AP_in_um', 'ML_in_um', 'cell_type'});
end
ActiveNeuronIndexOld      = ActiveNeuronIndex;
load([TempDatDir 'Shuffle_HiSpikes.mat'])  
nDataSet                  = [nDataSetOld'; nDataSet];
ActiveNeuronIndex         = [ActiveNeuronIndexOld; ActiveNeuronIndex];

%% Single LDA of trial type across time
ROCThres            = 0.5;
selectedNeuronalIndex = ActiveNeuronIndex';
selectedNeuronalIndex = selectedHighROCneurons(nDataSet, params, ROCThres, selectedNeuronalIndex);
numFold             = 30;
numRandPickUnits    = sum(selectedNeuronalIndex);
numTrials           = numRandPickUnits*6;
totTargets          = [true(numTrials/2,1); false(numTrials/2,1)];
timePoints          = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
nDataSet            = nDataSet(selectedNeuronalIndex);
numUnits            = length(nDataSet);
numT                = length(params.timeSeries);
numEpochs           = 4;

corrMat             = nan(numFold, numUnits, numEpochs);

for nFold             = 1:numFold
    nSessionData      = shuffleSessionData(nDataSet, totTargets, numTrials);
    nSessionData      = normalizationDim(nSessionData, 2);
    for nPeriod       = 1:numEpochs
        coeffs            = coeffTrialLDA(nSessionData(:, :, timePoints(nPeriod)+1:timePoints(nPeriod+1)), totTargets);
        corrMat(nFold, :, nPeriod) = coeffs;
    end
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
    for nPeriod       = 1:numEpochs
        coeffs              = squeeze(corrMat(nFold, :, nPeriod));
        LDAscore(timePoints(nPeriod)+1:timePoints(nPeriod+1))            = coeffs * actMat(:, timePoints(nPeriod)+1:timePoints(nPeriod+1));
        LDAscore((timePoints(nPeriod)+1:timePoints(nPeriod+1))+numT)            = coeffs * actMat(:, (timePoints(nPeriod)+1:timePoints(nPeriod+1))+numT);
    end
    plot(params.timeSeries, LDAscore(1:numT), '-r')
    plot(params.timeSeries, LDAscore(1+numT:end), '-b')
end
gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5)
hold off
box off
xlim([min(params.timeSeries) max(params.timeSeries)]);
xlabel('Time (s)')
ylabel('Trial-based LDA score (Hz)') 
setPrint(8, 6, 'Plots/CollectedUnitsEpochLDATrace')