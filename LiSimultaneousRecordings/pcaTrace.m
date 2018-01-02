addpath('../Func');
addpath('../Release_LDSI_v3')
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
nSession            = 17;
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
setPrint(8, 6, 'Plots/NeuralspacePCA')

xDimSet      = [2, 3, 4, 2, 4, 2, 4, 3, 5, 3, 4, 5, 5, 6, 5, 5, 4, 4, 3, 3, 4, 6];
optFitSet    = [6,10,11,10,30,18,19,27, 9,11, 9,30,13,11,30,25,11, 9,30,22, 1,15];
Y          = nDataSet(nSession).unit_yes_trial;
Y          = permute(Y, [2 3 1]);
yDim       = size(Y, 1);
T          = size(Y, 2);    
m          = ceil(yDim/4)*2;
xDim       = xDimSet(nSession);
optFit     = optFitSet(nSession);
load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
[~, y_est] = kfilter (Y, Ph, [0, timePoint, T]);
y_est      = permute(y_est, [3 1 2]);

traceData           = y_est;
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
setPrint(8, 6, 'Plots/NeuralspaceTLDSPCA')


addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;


% examples
exampleSets         = [1 6 11 16 21 26 31 36 41];
traceData           = nDataSet(nSession).unit_yes_trial;
for nUnit           = 1:size(traceData, 2)
    nUnitData       = squeeze(traceData(:, nUnit, :));
    nUnitData       = getGaussianPSTH (filterInUse, nUnitData, 2);
    traceData(:, nUnit, :) = nUnitData;
end
pcaCoeff             = pca(squeeze(mean(traceData))', 'NumComponents', 2);

figure;
hold on
for nTrial  = exampleSets
    traceTrial = squeeze(traceData(nTrial, :, :))' * pcaCoeff;
    plot(traceTrial(timePoint(1)-3:timePoint(end)+10, 1), traceTrial(timePoint(1)-3:timePoint(end)+10, 2), 'color', [0.7 0.7 0.7]);
    plot(traceTrial(timePoint(1),1), traceTrial(timePoint(1),2), 'ob')
    plot(traceTrial(timePoint(2),1), traceTrial(timePoint(2),2), 'or')
    plot(traceTrial(timePoint(3),1), traceTrial(timePoint(3),2), 'og')
end

setPrint(8, 6, 'Plots/NeuralspacePCAExample')


xDimSet      = [2, 3, 4, 2, 4, 2, 4, 3, 5, 3, 4, 5, 5, 6, 5, 5, 4, 4, 3, 3, 4, 6];
optFitSet    = [6,10,11,10,30,18,19,27, 9,11, 9,30,13,11,30,25,11, 9,30,22, 1,15];
Y          = nDataSet(nSession).unit_yes_trial;
Y          = permute(Y, [2 3 1]);
yDim       = size(Y, 1);
T          = size(Y, 2);    
m          = ceil(yDim/4)*2;
xDim       = xDimSet(nSession);
optFit     = optFitSet(nSession);
load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
[~, y_est] = kfilter (Y, Ph, [0, timePoint, T]);
y_est      = permute(y_est, [3 1 2]);

traceData           = y_est;
for nUnit           = 1:size(traceData, 2)
    nUnitData       = squeeze(traceData(:, nUnit, :));
    nUnitData       = getGaussianPSTH (filterInUse, nUnitData, 2);
    traceData(:, nUnit, :) = nUnitData;
end
pcaCoeff             = pca(squeeze(mean(traceData))', 'NumComponents', 2);

figure;
hold on
for nTrial  = exampleSets
    traceTrial = squeeze(traceData(nTrial, :, :))' * pcaCoeff;
    plot(traceTrial(timePoint(1)-3:timePoint(end)+10, 1), traceTrial(timePoint(1)-3:timePoint(end)+10, 2), 'color', [0.01 0.01 0.01]*nTrial);
    plot(traceTrial(timePoint(1),1), traceTrial(timePoint(1),2), 'ob')
    plot(traceTrial(timePoint(2),1), traceTrial(timePoint(2),2), 'or')
    plot(traceTrial(timePoint(3),1), traceTrial(timePoint(3),2), 'og')
end

setPrint(8, 6, 'Plots/NeuralspaceTLDSPCAExample')