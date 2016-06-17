addpath('../Func');
setDir;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
contraIndexSession = nan(numSession, 1);

for nSession = 1:numSession
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    numTrials   = numYesTrial + numNoTrial;
    Y          = permute(Y, [2 3 1]);

    yesActMat   = nan(size(Y, 1), length(params.timeSeries));
    noActMat    = nan(size(Y, 1), length(params.timeSeries));
    timePoints  = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
    contraIndex = false(size(Y,1), 1);

    for nUnit   = 1:size(Y, 1)
        yesTrial = squeeze(mean(Y(nUnit,:, 1:numYesTrial), 3));
        noTrial  = squeeze(mean(Y(nUnit,:, 1+numYesTrial:end), 3));
        yesActMat(nUnit, :)  = yesTrial;
        noActMat(nUnit, :)   = noTrial;
        contraIndex(nUnit)   = sum(noTrial(timePoints(2):end))<sum(yesTrial(timePoints(2):end));
    end
    
    contraIndexSession(nSession) = mean(contraIndex);
    
end

load([TempDatDir 'SimilarityIndexHi.mat'])

contraSimilarity = nan(numSession * 5, 1);
ipsiSimilarity   = nan(numSession * 5, 1);
contraPercentage = nan(numSession * 5, 1);
EpochGroup       = nan(numSession * 5, 1);

for nSession = 1:numSession
    contraSimilarity((nSession-1)*5 + (1:5)) = squeeze(TLDSMean(nSession, 2, :));
    ipsiSimilarity((nSession-1)*5 + (1:5))   = squeeze(TLDSMean(nSession, 3, :));
    contraPercentage((nSession-1)*5 + (1:5)) = contraIndexSession(nSession);
    EpochGroup((nSession-1)*5 + (1:5))       = 1:5;
end

markerSet = {'s', 'd', 'o', 'p', 'h'};
figure;
hold on
for nEpoch = 1:5
    scatter(ipsiSimilarity(EpochGroup==nEpoch), contraSimilarity(EpochGroup==nEpoch), [], contraPercentage(EpochGroup==nEpoch), 'filled', markerSet{nEpoch})
end
plot([0 1], [0 1], '--k')
xlim([0 1])
ylim([0 1])

xlabel('ipsi similarity')
xlabel('contra similarity')

setPrint(8, 6, 'Plots/TLDSLDASimilarityContraPreference')