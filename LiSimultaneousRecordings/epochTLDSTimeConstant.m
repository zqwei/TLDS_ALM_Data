addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_Spikes.mat'])

binsize      = params.binsize;
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [ 2,  3,  4,  2,  4,  2,  4,  3];
optFitSet    = [ 6, 10, 11, 10, 30, 18, 19, 27];


for nSession = 1:numSession
    xDim      = xDimSet(nSession);
    optFit    = optFitSet(nSession);
    load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    timeConst = nan(1, 4);
    for nEpoch = 1:4
        A    = Ph.A(:,:, nEpoch);
        EigSet = real(eig(A));
%         sEig   = max(EigSet(EigSet<1));
%         timeConst(nEpoch) = binsize/(1- sEig);
        timeConst(nEpoch) = max(EigSet);
    end
    disp(timeConst)
end

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
xDimSet      = [3, 3, 4, 3, 3, 5, 5, 4, 4, 4, 4];
optFitSet    = [4, 25, 7, 20, 8, 10, 1, 14, 15, 10, 15];
numSessionHi   = length(nDataSet);

for nSession = 1:numSessionHi
    xDim      = xDimSet(nSession);
    optFit    = optFitSet(nSession);
    load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    timeConst = nan(1, 4);
    for nEpoch = 1:4
        A    = Ph.A(:,:, nEpoch);
        EigSet = real(eig(A));
%         sEig   = max(EigSet(EigSet<1));
%         timeConst(nEpoch) = binsize/(1- sEig);
        timeConst(nEpoch) = max(EigSet);
    end
    disp(timeConst)
end