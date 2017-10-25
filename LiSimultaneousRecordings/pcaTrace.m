addpath('../Func');
setDir;


load([TempDatDir 'Simultaneous_Spikes.mat'])

sigma                         = 0.15 / params.binsize; % 300 ms
filterLength                  = 11;
filterStep                    = linspace(-filterLength / 2, filterLength / 2, filterLength);
filterInUse                   = exp(-filterStep .^ 2 / (2 * sigma ^ 2));
filterInUse                   = filterInUse / sum (filterInUse); 


timePoints          = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
numEpochs           = 4;
nSession            = 18;
traceData           = nDataSet(nSession).unit_no_trial;
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
    plot(traceTrial(:, 1), traceTrial(:, 2), 'color', [0.7 0.7 0.7]);
end

traceAve = squeeze(mean(traceData,1))' * pcaCoeff;

plot(traceAve(:,1), traceAve(:,2), 'k')