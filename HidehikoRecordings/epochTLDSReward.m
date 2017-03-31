addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
corrDataSet  = nDataSet;

load([TempDatDir 'SimultaneousError_HiSpikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [3, 3, 4, 3, 3, 5, 5, 4, 4, 4, 4, 5, 4, 4, 4, 4, 4, 3];
optFitSet    = [4, 25, 7, 20, 8, 10, 1, 14, 15, 10, 15, 20, 5, 27, 9, 24, 11, 19];
cmap                = cbrewer('div', 'Spectral', 128, 'cubic');

for nSession = 3 %1:numSession
    figure;
    Y          = [corrDataSet(nSession).unit_yes_trial; corrDataSet(nSession).unit_no_trial];
    numYesTrial = size(corrDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(corrDataSet(nSession).unit_no_trial, 1);
    Y          = permute(Y, [2 3 1]);
    T          = size(Y, 2);
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [~, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);
    totTargets    = true(numYesTrial+numNoTrial, 1);
    nSessionData  = permute(y_est, [3 1 2]);

    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    numTrials   = numYesTrial + numNoTrial;
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [~, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);
    totTargets    = [totTargets; false(numYesTrial+numNoTrial, 1)];
    nSessionData  = [nSessionData; permute(y_est, [3 1 2])];
            
    nSessionData  = normalizationDim(nSessionData, 2);  
    [coeffs, ~, ~, correctRate] = coeffSLDA(nSessionData, totTargets);
%     coeffs = randn(size(nSessionData, 2),T);
    coeffs = bsxfun(@rdivide, coeffs, std(coeffs, [], 1));
    scoreMat      = nan(size(nSessionData, 1), size(nSessionData, 3));    
    
    
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        scoreMat(:, nTime) = scoreMat(:, nTime) - mean(scoreMat(:, nTime)); % remove the momental mean
    end
    
%     figure;
%     subplot(1, 2, 1)
%     hold on
%     scoreMatC     = scoreMat(totTargets, :);
%     plot(params.timeSeries, scoreMatC(1:8, :), '-m')
%     scoreMatE     = scoreMat(~totTargets, :);
%     numErrorTrial = size(scoreMatE, 1);
%     plot(params.timeSeries, scoreMatE(1:min(8, numErrorTrial), :), '-g')    
%     gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
%     xlim([min(params.timeSeries) max(params.timeSeries)]);
%     box off
%     hold off
%     xlabel('Time (s)')
%     ylabel('LDA score')
%     title('Score using instantaneous LDA')
%     set(gca, 'TickDir', 'out')
% 
%     subplot(1, 2, 2)
%     hold on
%     % plot(params.timeSeries, correctRate, '-k')
%     shadedErrorBar(params.timeSeries, correctRate,sqrt(correctRate.*(1-correctRate)/length(totTargets)),{'-k','linewid',1},0.5);
%     gridxy ([params.polein, params.poleout, 0],[mean(totTargets)], 'Color','k','Linestyle','--','linewid', 0.5);
%     xlim([min(params.timeSeries) max(params.timeSeries)]);
%     box off
%     hold off
%     xlabel('Time (s)')
%     ylabel('Decodability of reward')
%     title('Score using instantaneous LDA')
%     set(gca, 'TickDir', 'out')
    
%     setPrint(8*2, 6*1, ['Plots/TLDSLDASimilarityRewardExampleSesssion_idx_' num2str(nSession, '%02d')])
    
    figure;
    subplot(1, 3, 1)
    scoreMatC     = mean(scoreMat(totTargets, timePoint(1)-4:timePoint(1)-2), 2);
    scoreMatE     = mean(scoreMat(~totTargets, timePoint(1)-4:timePoint(1)-2), 2);
    hold on
    [fi, xi] = histcounts(scoreMatC, -0.4:0.04:0.4);
    stairs(xi(1:end-1), fi/sum(fi), 'm')
    [fi, xi] = histcounts(scoreMatE, -0.4:0.04:0.4);
    stairs(xi(1:end-1), fi/sum(fi), 'g')
    box off
    hold off
    xlabel('LDA score')
    ylabel('Fraction trial')
    xlim([-0.4 0.4])
    set(gca, 'TickDir', 'out')  
    title('Late Presample')
    
    subplot(1, 3, 2)
    scoreMatC     = mean(scoreMat(totTargets, timePoint(2)+4:timePoint(3)-2), 2);
    scoreMatE     = mean(scoreMat(~totTargets, timePoint(2)+4:timePoint(3)-2), 2);
    hold on
    [fi, xi] = histcounts(scoreMatC, -0.4:0.02:0.4);
    stairs(xi(1:end-1), fi/sum(fi), 'm')
    [fi, xi] = histcounts(scoreMatE, -0.4:0.02:0.4);
    stairs(xi(1:end-1), fi/sum(fi), 'g')
    box off
    hold off
    xlabel('LDA score')
    ylabel('Fraction trial')
    xlim([-0.4 0.4])
    set(gca, 'TickDir', 'out')  
    title('Middle Delay')
    
    subplot(1, 3, 3)
    scoreMatC     = mean(scoreMat(totTargets, timePoint(3):timePoint(3)+4), 2);
    scoreMatE     = mean(scoreMat(~totTargets, timePoint(3):timePoint(3)+4), 2);
    hold on
    [fi, xi] = histcounts(scoreMatC, -0.4:0.04:0.4);
    stairs(xi(1:end-1), fi/sum(fi), 'm')
    [fi, xi] = histcounts(scoreMatE, -0.4:0.04:0.4);
    stairs(xi(1:end-1), fi/sum(fi), 'g')
    box off
    hold off
    xlabel('LDA score')
    ylabel('Fraction trial')
    xlim([-0.4 0.4])
    set(gca, 'TickDir', 'out')  
    title('Early Response')
%     setPrint(8*3, 6*1, ['Plots/TLDSLDASimilarityRewardExampleSesssion_Dist_idx_' num2str(nSession, '%02d')])
    
    
    figure;
    hold on
    scoreMatC     = mean(scoreMat(totTargets, timePoint(1)-4:timePoint(1)-2), 2);
    scoreMatE     = mean(scoreMat(~totTargets, timePoint(1)-4:timePoint(1)-2), 2);
    [fic, ~] = histcounts(scoreMatC, -0.4:0.04:0.4);
    [fie, ~] = histcounts(scoreMatE, -0.4:0.04:0.4);
    stairs(cumsum(fie)/sum(fie), cumsum(fic)/sum(fic), 'r','linewid',1)
    box off
    
    scoreMatC     = mean(scoreMat(totTargets, timePoint(2)+4:timePoint(3)-2), 2);
    scoreMatE     = mean(scoreMat(~totTargets, timePoint(2)+4:timePoint(3)-2), 2);
    [fic, ~] = histcounts(scoreMatC, -0.4:0.02:0.4);
    [fie, ~] = histcounts(scoreMatE, -0.4:0.02:0.4);
    stairs(cumsum(fie)/sum(fie), cumsum(fic)/sum(fic), 'b','linewid',1)
    
    scoreMatC     = mean(scoreMat(totTargets, timePoint(3):timePoint(3)+4), 2);
    scoreMatE     = mean(scoreMat(~totTargets, timePoint(3):timePoint(3)+4), 2);
    [fic, ~] = histcounts(scoreMatC, -0.4:0.04:0.4);
    [fie, ~] = histcounts(scoreMatE, -0.4:0.04:0.4);
    stairs(cumsum(fie)/sum(fie), cumsum(fic)/sum(fic), 'k','linewid',1)
    
    plot([0 1], [0 1],'--k')
    hold off
    xlabel('P(error)')
    ylabel('P(correct)')
    set(gca, 'TickDir', 'out')  

end

% close all