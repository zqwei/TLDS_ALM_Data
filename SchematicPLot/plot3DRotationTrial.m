addpath('../Func');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])

timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
dimPCA       = 3;
sigma                         = 0.15 / params.binsize; % 300 ms
filterLength                  = 11;
filterStep                    = linspace(-filterLength / 2, filterLength / 2, filterLength);
filterInUse                   = exp(-filterStep .^ 2 / (2 * sigma ^ 2));
filterInUse                   = filterInUse / sum (filterInUse); 



for nSession = 11%1:numSession-1
    Y          = [nDataSet(nSession).x_yes_fit; nDataSet(nSession).x_no_fit];
    Y          = permute(Y, [2 1 3]);
    pcaY       = reshape(Y, size(Y, 1), []);
    [~, pcaY]  = pca(pcaY');
    pcaY       = pcaY';
    pcaY       = reshape(pcaY, size(Y, 1), size(Y, 2), size(Y, 3));
    numYes     = sum(nDataSet(nSession).totTargets);
    
%     figure;
%     hold on
%     for nTrial = 2:2:10
%         nTrialpcaY = squeeze(pcaY(:, nTrial, :));
%         plot3(nTrialpcaY(1,:), nTrialpcaY(2,:), nTrialpcaY(3,:),'k')
%         plot3(nTrialpcaY(1,timePoint(1)), nTrialpcaY(2,timePoint(1)), nTrialpcaY(3,timePoint(1)),'og')
%         plot3(nTrialpcaY(1,timePoint(2)), nTrialpcaY(2,timePoint(2)), nTrialpcaY(3,timePoint(2)),'ob')
%         plot3(nTrialpcaY(1,timePoint(3)), nTrialpcaY(2,timePoint(3)), nTrialpcaY(3,timePoint(3)),'om')
%     end

    figure;
    hold on
    for nTrial = 1:10
        nTrialpcaY = squeeze(pcaY(:, nTrial, :));
        plot(nTrialpcaY(1,:), nTrialpcaY(2,:))
        plot(nTrialpcaY(1,timePoint(1)), nTrialpcaY(2,timePoint(1)),'og','markersize', 2)
        plot(nTrialpcaY(1,timePoint(2)), nTrialpcaY(2,timePoint(2)),'ob','markersize', 2)
        plot(nTrialpcaY(1,timePoint(3)), nTrialpcaY(2,timePoint(3)),'om','markersize', 2)
    end
    
    setPrint(8, 6, 'TLDS_PC')

    
%     for nTrial = numYes+2:2:numYes+10
%         nTrialpcaY = squeeze(pcaY(:, nTrial, :));
%         plot3(nTrialpcaY(1,:), nTrialpcaY(2,:), nTrialpcaY(3,:),'r')
%         plot3(nTrialpcaY(1,timePoint(1)), nTrialpcaY(2,timePoint(1)), nTrialpcaY(3,timePoint(1)),'og')
%         plot3(nTrialpcaY(1,timePoint(2)), nTrialpcaY(2,timePoint(2)), nTrialpcaY(3,timePoint(2)),'ob')
%         plot3(nTrialpcaY(1,timePoint(3)), nTrialpcaY(2,timePoint(3)), nTrialpcaY(3,timePoint(3)),'om')
%     end

    
    
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    Y          = permute(Y, [2 1 3]);
    pcaY       = reshape(Y, size(Y, 1), []);
    [~, pcaY]  = pca(pcaY');
    pcaY       = pcaY';
    pcaY       = reshape(pcaY, size(Y, 1), size(Y, 2), size(Y, 3));
    
    figure;
    hold on
    for nTrial = 1:10
        nTrialpcaY = squeeze(pcaY(:, nTrial, :));
        nTrialpcaY = getGaussianPSTH (filterInUse, nTrialpcaY, 2);
        plot(nTrialpcaY(1,:), nTrialpcaY(2,:));
        plot(nTrialpcaY(1,timePoint(1)), nTrialpcaY(2,timePoint(1)),'og','markersize', 2)
        plot(nTrialpcaY(1,timePoint(2)), nTrialpcaY(2,timePoint(2)),'ob','markersize', 2)
        plot(nTrialpcaY(1,timePoint(3)), nTrialpcaY(2,timePoint(3)),'om','markersize', 2)
    end
    
    setPrint(8, 6, 'raw_PC')
    
end