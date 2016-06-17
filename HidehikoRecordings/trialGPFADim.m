addpath('../Func');
addpath(genpath('../gpfa_v0203'))
setDir;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
numSession   = length(nDataSet);
kernSD       = 0;

for nSession = 1%:numSession
    method = plotPredErrorVsDim(nSession, kernSD);
    save([TempDatDir 'GPFASessionHi_' num2str(nSession) '.mat'],'method');
    setPrint(12, 9, ['GPFAPlots/GPFAModelComparison_Session_' num2str(nSession)])
end

close all