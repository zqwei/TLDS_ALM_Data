addpath('../Func');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])

for nData = 17%1:length(nDataSet)
    param          = params(nDataSet(nData).task_type);
    timePoint      = timePointTrialPeriod(param.polein, param.poleout, param.timeSeries);
    
    totTargets    = nDataSet(nData).totTargets;
    numUnits      = length(nDataSet(nData).nUnit);
    numTrials     = length(totTargets);
    numYesTrial   = sum(totTargets);
    nSessionData  = [nDataSet(nData).unit_KF_yes_fit; nDataSet(nData).unit_KF_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    nPeriodData   = nan(size(nSessionData,1), size(nSessionData,2), length(timePoint)-1);
    for nPeriod   = 1:length(timePoint)-1
        nPeriodData(:, :, nPeriod) = mean(nSessionData(:, :, timePoint(nPeriod):timePoint(nPeriod+1)), 3);
    end
    coeffs        = coeffLDA(nPeriodData, totTargets);
    scoreMat      = nan(numTrials, size(nPeriodData, 3));
    for nTime     = 1:size(nPeriodData, 3)
        scoreMat(:, nTime) = squeeze(nPeriodData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    imageMat      = false(length(totTargets),sum(totTargets)*5);
    for nTrial    = 1:numTrials
        for nEpoch= 1:size(nPeriodData, 3)
            [~, rank_] = sort(scoreMat(:, nEpoch));
            imageMat(rank_(nTrial), (nTrial-1)*5 + nEpoch) = true;
        end
    end
    figure
    imagesc(imageMat)
    
end