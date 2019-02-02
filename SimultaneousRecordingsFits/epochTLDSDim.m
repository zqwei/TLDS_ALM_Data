addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_Spikes.mat'])
mean_type    = 'Constant_mean';
tol          = 1e-3;
cyc          = 10000;
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
nFold        = 10;
bestModelIdx = 4;
thres        = 0.8;

Err_set      = zeros(numSession, 4);

for nSession = 1:numSession
    xDim       = size(nDataSet(nSession).unit_yes_trial, 2)-2;
    load([TempDatDir 'Session_' num2str(nSession) '.mat'],'err_model1','err_model2', 'err_model3', 'err_model4');
%     figure;
    Err_all    = 100 - [mean(err_model1');mean(err_model2');mean(err_model3');mean(err_model4')]*100;
    Err_set(nSession, :) = max(Err_all, [], 2);
%     Std_all    = [std(err_model1');std(err_model2');std(err_model3');std(err_model4')]/sqrt(nFold)*100;    
%     [maxEV, maxIdx] = max(Err_all(bestModelIdx, :));
%     optIdx     = find(Err_all(bestModelIdx, :)>maxEV*thres, 1, 'first');
%     disp(size(Err_all, 2) - length(nDataSet(nSession).nUnit))
%     hold on
%     errorbar((1:xDim)'*ones(1,4), Err_all',Std_all', '-o','linewid',1)
%     plot([optIdx, maxIdx], [maxEV, maxEV], '+k')
%     hold off
%     xlabel('Latent Dimension');
%     ylabel('% Exp. Var.');
%     xlim([0.5 xDim+1]);
%     ylim([0 ceil(max(Err_all(:)+Std_all(:)))])
%     box off
%     setPrint(6, 4.5, ['LDSPlots/LDSModelComparison_Session_' num2str(nSession)])
%     close all
end

save('Err_set.mat', 'Err_set')