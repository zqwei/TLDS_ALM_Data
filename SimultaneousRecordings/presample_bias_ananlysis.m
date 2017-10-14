addpath('../Func');
setDir;

load([TempDatDir 'Simultaneous_Spikes.mat'])
load([TempDatDir 'Shuffle_Spikes.mat'], 'CR')
sessionIndex = [nDataSet.sessionIndex];
sessionCR    = CR(sessionIndex,:);
sessionCRold = sessionCR;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
load([TempDatDir 'Shuffle_HiSpikes.mat'], 'CR')
sessionIndex = [nDataSet.sessionIndex];
sessionCR    = CR(sessionIndex,:);
sessionCR    = [sessionCRold; sessionCR];


load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(1:2);
numSession   = length(nDataSet);
kFold        = 10;
dprimeSession    = zeros(numSession, 1);
LDAdprimeSession = zeros(numSession, 1);
LDA_performance  = zeros(numSession, 2);
TLDS_performance = zeros(numSession, 2);

% d-prime
for nSession = 1:numSession
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    Y          = permute(Y, [2 3 1]);
    totTargets = nDataSet(nSession).totTargets;
    neuroMat   = squeeze(mean(Y(:, timePoint(1):timePoint(2), :), 2));
    
    L          = 1 - kfoldLoss(fitcdiscr(neuroMat', totTargets, ...
                 'discrimType','pseudoLinear', 'KFold', kFold),...
                 'lossfun', 'classiferror', 'mode', 'individual');
    meanDff    = mean(neuroMat(:, totTargets), 2)-mean(neuroMat(:, ~totTargets), 2);
    varDff     = var(neuroMat(:, totTargets), 0,2) + var(neuroMat(:, ~totTargets), 0, 2);
    dprimeSession(nSession)     = mean(abs(meanDff)./sqrt(varDff));
    LDA_performance(nSession,1) = mean(L);
    LDA_performance(nSession,2) = std(L)/sqrt(kFold);
    
    nSessionData  = [nDataSet(nSession).unit_yes_fit; nDataSet(nSession).unit_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(size(nSessionData, 1), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    neuroMat   = scoreMat(:, timePoint(1):timePoint(2));
    L          = 1 - kfoldLoss(fitcdiscr(neuroMat, totTargets, ...
                 'discrimType','pseudoLinear', 'KFold', kFold),...
                 'lossfun', 'classiferror', 'mode', 'individual');
    TLDS_performance(nSession,1) = mean(L);
    TLDS_performance(nSession,2) = std(L)/sqrt(kFold);

end

figure
plot(abs(sessionCR(:,1)-sessionCR(:,2)), dprimeSession, 'o')
xlabel('|CR(L)-CR(R)|')
ylabel('d-prime')

figure
plot(abs(sessionCR(:,1)-sessionCR(:,2)), LDA_performance(:,1), 'o')
xlabel('|CR(L)-CR(R)|')
ylabel('LDA performance')