addpath('../Func');
setDir;


load([TempDatDir 'Simultaneous_Spikes.mat'])

sigma        = 0.15 / params.binsize; % 300 ms
filterLength = 11;
filterStep   = linspace(-filterLength / 2, filterLength / 2, filterLength);
filterInUse  = exp(-filterStep .^ 2 / (2 * sigma ^ 2));
filterInUse  = filterInUse / sum (filterInUse); 
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);

timePoints          = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
numEpochs           = 4;
nSession            = 18;
traceData           = nDataSet(nSession).unit_yes_trial;
for nUnit           = 1:size(traceData, 2)
    nUnitData       = squeeze(traceData(:, nUnit, :));
    nUnitData       = getGaussianPSTH (filterInUse, nUnitData, 2);
    traceData(:, nUnit, :) = nUnitData;
end
pcaCoeff             = pca(squeeze(mean(traceData))', 'NumComponents', 2);

figure;
hold on
for nTrial  = 1:size(traceData, 1)
    traceTrial = squeeze(traceData(nTrial, :, :))' * pcaCoeff;
    plot(traceTrial(timePoint(1)-3:timePoint(end)+10, 1), traceTrial(timePoint(1)-3:timePoint(end)+10, 2), 'color', [0.7 0.7 0.7]);
end

traceAve = squeeze(mean(traceData,1))' * pcaCoeff;

plot(traceAve(timePoint(1)-3:timePoint(end)+10,1), traceAve(timePoint(1)-3:timePoint(end)+10,2), 'k')
plot(traceAve(timePoint,1), traceAve(timePoint,2), 'or')



traceData           = nDataSet(nSession).unit_yes_trial;
for nUnit           = 1:size(traceData, 2)
    nUnitData       = squeeze(traceData(:, nUnit, :));
    nUnitData       = getGaussianPSTH (filterInUse, nUnitData, 2);
    traceData(:, nUnit, :) = nUnitData;
end
pcaCoeff             = pca(squeeze(mean(traceData))', 'NumComponents', 2);

figure;
hold on
for nTrial  = 1:size(traceData, 1)
    traceTrial = squeeze(traceData(nTrial, :, :))' * pcaCoeff;
    plot(traceTrial(timePoint(1)-3:timePoint(end)+10, 1), traceTrial(timePoint(1)-3:timePoint(end)+10, 2), 'color', [0.7 0.7 0.7]);
end

traceAve = squeeze(mean(traceData,1))' * pcaCoeff;

plot(traceAve(timePoint(1)-3:timePoint(end)+10,1), traceAve(timePoint(1)-3:timePoint(end)+10,2), 'k')
plot(traceAve(timePoint,1), traceAve(timePoint,2), 'or')