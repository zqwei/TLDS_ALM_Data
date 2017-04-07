addpath('../Func');
setDir;

load([TempDatDir 'Combined_Simultaneous_Error_Spikes.mat'])
errDataSet   = nDataSet;
load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
corrDataSet  = nDataSet;

timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
dimPCA       = 3;
sigma                         = 0.15 / params.binsize; % 300 ms
filterLength                  = 11;
filterStep                    = linspace(-filterLength / 2, filterLength / 2, filterLength);
filterInUse                   = exp(-filterStep .^ 2 / (2 * sigma ^ 2));
filterInUse                   = filterInUse / sum (filterInUse); 



for nSession = 22%1:numSession-1
    Y          = [corrDataSet(nSession).x_yes_fit; corrDataSet(nSession).x_no_fit];
    Y          = permute(Y, [2 1 3]);
    pcaY       = reshape(Y, size(Y, 1), []);
    [~, pcaY]  = pca(pcaY');
    pcaY       = pcaY';
    pcaY       = reshape(pcaY, size(Y, 1), size(Y, 2), size(Y, 3));
    numYes     = sum(corrDataSet(nSession).totTargets);
    numTrials  = length(corrDataSet(nSession).totTargets);
    
    figure;
    hold on
%     for nTrial = 1:numYes
%         nTrialpcaY = squeeze(pcaY(:, nTrial, :));
%         plot(nTrialpcaY(1,4:timePoint(3)+5), nTrialpcaY(2,4:timePoint(3)+5), 'color', [0.3000    0.7500    0.9300])
%     end
    
    nTrialpcaY = squeeze(mean(pcaY(:, corrDataSet(nSession).totTargets, :), 2));
    plot3(nTrialpcaY(1,4:timePoint(3)+5), nTrialpcaY(2,4:timePoint(3)+5), nTrialpcaY(3,4:timePoint(3)+5), 'b', 'linewid', 1)
    plot3(nTrialpcaY(1,timePoint(1)), nTrialpcaY(2,timePoint(1)), nTrialpcaY(3,timePoint(1)),'og','markersize', 2)
    plot3(nTrialpcaY(1,timePoint(2)), nTrialpcaY(2,timePoint(2)), nTrialpcaY(3,timePoint(2)),'ob','markersize', 2)
    plot3(nTrialpcaY(1,timePoint(3)), nTrialpcaY(2,timePoint(3)), nTrialpcaY(3,timePoint(3)),'om','markersize', 2)
    
    
    hold on
%     for nTrial = 1+numYes:numTrials
%         nTrialpcaY = squeeze(pcaY(:, nTrial, :));
%         plot(nTrialpcaY(1,4:timePoint(3)+5), nTrialpcaY(2,4:timePoint(3)+5), 'color', [0.9300    0.7500    0.3000])
%     end
    
    nTrialpcaY = squeeze(mean(pcaY(:, ~corrDataSet(nSession).totTargets, :), 2));
    plot3(nTrialpcaY(1,4:timePoint(3)+5), nTrialpcaY(2,4:timePoint(3)+5), nTrialpcaY(3,4:timePoint(3)+5), 'r', 'linewid', 1)
    plot3(nTrialpcaY(1,timePoint(1)), nTrialpcaY(2,timePoint(1)), nTrialpcaY(3,timePoint(1)),'og','markersize', 2)
    plot3(nTrialpcaY(1,timePoint(2)), nTrialpcaY(2,timePoint(2)), nTrialpcaY(3,timePoint(2)),'ob','markersize', 2)
    plot3(nTrialpcaY(1,timePoint(3)), nTrialpcaY(2,timePoint(3)), nTrialpcaY(3,timePoint(3)),'om','markersize', 2)
    
    
    
    Y          = [errDataSet(nSession).x_yes_fit; errDataSet(nSession).x_no_fit];
    Y          = permute(Y, [2 1 3]);
    pcaY       = reshape(Y, size(Y, 1), []);
    [~, pcaY]  = pca(pcaY');
    pcaY       = pcaY';
    pcaY       = reshape(pcaY, size(Y, 1), size(Y, 2), size(Y, 3));
    numYes     = sum(errDataSet(nSession).totTargets);
    numTrials  = length(errDataSet(nSession).totTargets);
    
    hold on
%     for nTrial = 1:numYes
%         nTrialpcaY = squeeze(pcaY(:, nTrial, :));
%         plot(nTrialpcaY(1,4:timePoint(3)+5), nTrialpcaY(2,4:timePoint(3)+5), 'color', [0.3000    0.7500    0.9300])
%     end
    
    nTrialpcaY = squeeze(mean(pcaY(:, errDataSet(nSession).totTargets, :), 2));
    plot3(nTrialpcaY(1,4:timePoint(3)+5), nTrialpcaY(2,4:timePoint(3)+5), nTrialpcaY(3,4:timePoint(3)+5), '--b', 'linewid', 1)
    plot3(nTrialpcaY(1,timePoint(1)), nTrialpcaY(2,timePoint(1)), nTrialpcaY(3,timePoint(1)),'og','markersize', 2)
    plot3(nTrialpcaY(1,timePoint(2)), nTrialpcaY(2,timePoint(2)), nTrialpcaY(3,timePoint(2)),'ob','markersize', 2)
    plot3(nTrialpcaY(1,timePoint(3)), nTrialpcaY(2,timePoint(3)), nTrialpcaY(3,timePoint(3)),'om','markersize', 2)
    
    
    hold on
%     for nTrial = 1+numYes:numTrials
%         nTrialpcaY = squeeze(pcaY(:, nTrial, :));
%         plot(nTrialpcaY(1,4:timePoint(3)+5), nTrialpcaY(2,4:timePoint(3)+5), 'color', [0.9300    0.7500    0.3000])
%     end
    
    nTrialpcaY = squeeze(mean(pcaY(:, ~errDataSet(nSession).totTargets, :), 2));
    plot3(nTrialpcaY(1,4:timePoint(3)+5), nTrialpcaY(2,4:timePoint(3)+5), nTrialpcaY(3,4:timePoint(3)+5), '--r', 'linewid', 1)
    plot3(nTrialpcaY(1,timePoint(1)), nTrialpcaY(2,timePoint(1)), nTrialpcaY(3,timePoint(1)),'og','markersize', 2)
    plot3(nTrialpcaY(1,timePoint(2)), nTrialpcaY(2,timePoint(2)), nTrialpcaY(3,timePoint(2)),'ob','markersize', 2)
    plot3(nTrialpcaY(1,timePoint(3)), nTrialpcaY(2,timePoint(3)), nTrialpcaY(3,timePoint(3)),'om','markersize', 2)
    
end