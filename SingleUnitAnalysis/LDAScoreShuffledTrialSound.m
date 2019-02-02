%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DV as a function of time, DV is defined using LDA projections
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;

ROCThres            = 0.5;

load([TempDatDir 'Shuffle_HiSoundSpikes.mat'])    
numUnits                  = length(nDataSet);
numT                      = length(params.timeSeries);

corrMat                   = nan(numUnits, numT);
numRandPickUnits          = numUnits;
numTrials                 = numRandPickUnits*6;
totTargets                = [true(numTrials/2,1); false(numTrials/2,1)];

currRandPickUnits     = numRandPickUnits;
nSessionData          = shuffleSessionData(nDataSet(randperm(numUnits, currRandPickUnits)), totTargets, numTrials);
nSessionData          = normalizationDim(nSessionData, 2);
coeffs                = coeffLDA(nSessionData, totTargets);

timePoint             = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);

figure;

for nTimePoint        = 1:3
    subplot(1, 3, nTimePoint)

    sampleCD              = mean(coeffs(:, timePoint(nTimePoint+1):timePoint(nTimePoint+2)), 2);
    neuralProj            = nan(size(nSessionData, 1), size(nSessionData, 3));
    for nTime             = 1:size(nSessionData, 3)
        neuralProj(:, nTime) = squeeze(nSessionData(:, :, nTime)) * sampleCD;
    end

    hold on
    shadedErrorBar(params.timeSeries, -mean(neuralProj(totTargets, :)), std(neuralProj(totTargets, :)), {'-b'})
    shadedErrorBar(params.timeSeries, -mean(neuralProj(~totTargets, :)), std(neuralProj(~totTargets, :)), {'-r'})
    xlim([min(params.timeSeries) 1.5]);
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA Time (s)')
    ylabel('LDA Time (s)')
    set(gca, 'TickDir', 'out')
end
setPrint(8*3, 6, 'Plots/SimilarityLDAScore_All')