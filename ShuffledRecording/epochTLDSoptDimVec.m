addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_Spikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [  2,  2,  4,  2,  3,  2,  4,  2;
                  0,  3,  0,  0,  4,  0,  0,  3];
optDim       =  [18, 24, 24, 11, 19, 20,  5, 26;
                  0, 29,  0,  0, 11,  0,  0, 24];
nFold        = 30;

for nSession = 1:numSession
    for nDim   = 1:size(xDimSet, 1)
        xDim       = xDimSet(nDim, nSession);
        if xDim>0            
            curr_err   = nan(nFold, 1);
            for n_fold = 1:nFold
                load([TempDatDir 'ShfSession_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(n_fold) '.mat'],'Ph', 'Y');
                T          = size(Y, 2);
                [curr_err(n_fold),~] = loo (Y, Ph, [0, timePoint, T]);
            end
            [~, optFit] = min(curr_err);
            disp([nSession, xDim, optFit])
        end
    end
end

close all


load([TempDatDir 'Simultaneous_HiSpikes.mat'])
mean_type    = 'Constant_mean';
tol          = 1e-6;
cyc          = 10000;
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [  3,  3,  3,  3,  2;
                  0,  0,  4,  0,  3];
optDim       = [ 24, 27,  6, 28,  9;
                  0,  0,  1,  0, 25];
nFold        = 30;

for nSession = 1:numSession    
    for nDim   = 1:size(xDimSet, 1)
        xDim       = xDimSet(nDim, nSession);
        if xDim>0
            curr_err   = nan(nFold, 1);
            for n_fold = 1:nFold
                load([TempDatDir 'ShfSessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(n_fold) '.mat'],'Ph', 'Y');
                T          = size(Y, 2);
                [curr_err(n_fold),~] = loo (Y, Ph, [0, timePoint, T]);
            end
            [~, optFit] = min(curr_err);
            disp([nSession, xDim, optFit])
        end
    end
end

close all