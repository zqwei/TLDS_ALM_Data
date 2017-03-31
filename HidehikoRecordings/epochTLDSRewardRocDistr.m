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
numRand      = 300;

for nSession = 3 % 1:numSession
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
    scoreMat      = nan(size(nSessionData, 1), size(nSessionData, 3));    
    
    
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        scoreMat(:, nTime) = scoreMat(:, nTime) - mean(scoreMat(:, nTime)); % remove the momental mean
    end

    figure;
    subplot(1, 3, 1)
    scoreMatC     = mean(scoreMat(totTargets, timePoint(1)-4:timePoint(1)-2), 2);
    scoreMatE     = mean(scoreMat(~totTargets, timePoint(1)-4:timePoint(1)-2), 2);
    stdAUC        = computeAUC(scoreMatC, scoreMatE, 0.02);
    randAUC       = nan(numRand, 1);
    for nRand     = 1:numRand
        coeffsRand   = randn(size(nSessionData, 2),1);
        scoreMatRand = squeeze(mean(nSessionData(:, :, timePoint(1)-4:timePoint(1)-2), 3)) * coeffsRand/std(coeffsRand, [], 1);
        randAUC(nRand) = computeAUC(scoreMatRand(totTargets), scoreMatRand(~totTargets), 0.02);
    end
    [fi, xi] = histcounts(randAUC, 0:0.02:1);
    stairs(xi(1:end-1), fi/sum(fi), 'b')
    hold on
    gridxy([stdAUC],[], 'Color','k','Linestyle','--','linewid', 0.5);
    box off
    xlabel('AUC')
    ylabel('Fraction trial')
    xlim([0 1])
    set(gca, 'TickDir', 'out')  
    title('Late Presample')
    
    subplot(1, 3, 2)
    scoreMatC     = mean(scoreMat(totTargets, timePoint(2)+4:timePoint(3)-2), 2);
    scoreMatE     = mean(scoreMat(~totTargets, timePoint(2)+4:timePoint(3)-2), 2);
    stdAUC        = computeAUC(scoreMatC, scoreMatE, 0.02);
    randAUC       = nan(numRand, 1);
    for nRand     = 1:numRand
        coeffsRand   = randn(size(nSessionData, 2),1);
        scoreMatRand = squeeze(mean(nSessionData(:, :, timePoint(2)+4:timePoint(3)-2), 3)) * coeffsRand/std(coeffsRand, [], 1);
        randAUC(nRand) = computeAUC(scoreMatRand(totTargets), scoreMatRand(~totTargets), 0.02);
    end
    [fi, xi] = histcounts(randAUC, 0:0.02:1);
    stairs(xi(1:end-1), fi/sum(fi), 'b')
    hold on
    gridxy([stdAUC],[], 'Color','k','Linestyle','--','linewid', 0.5);
    box off
    xlabel('AUC')
    ylabel('Fraction trial')
    xlim([0 1])
    set(gca, 'TickDir', 'out')  
    title('Middle Delay')

    subplot(1, 3, 3)
    scoreMatC     = mean(scoreMat(totTargets, timePoint(3):timePoint(3)+4), 2);
    scoreMatE     = mean(scoreMat(~totTargets, timePoint(3):timePoint(3)+4), 2);
    stdAUC        = computeAUC(scoreMatC, scoreMatE, 0.02);
    randAUC       = nan(numRand, 1);
    for nRand     = 1:numRand
        coeffsRand   = randn(size(nSessionData, 2),1);
        scoreMatRand = squeeze(mean(nSessionData(:, :, timePoint(3):timePoint(3)+4), 3)) * coeffsRand/std(coeffsRand, [], 1);
        randAUC(nRand) = computeAUC(scoreMatRand(totTargets), scoreMatRand(~totTargets), 0.02);
    end
    [fi, xi] = histcounts(randAUC, 0:0.02:1);
    stairs(xi(1:end-1), fi/sum(fi), 'b')
    hold on
    gridxy([stdAUC],[], 'Color','k','Linestyle','--','linewid', 0.5);
    box off
    xlabel('AUC')
    ylabel('Fraction trial')
    xlim([0 1])
    set(gca, 'TickDir', 'out')  
    title('Early Response')

end

% close all