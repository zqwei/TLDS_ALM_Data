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
xDimSet      = [ 2,  3,  4,  2,  4,  2,  4,  3];
optFitSet    = [ 6, 10, 11, 10, 30, 18, 19, 27];

for nSession = 1:numSession
    xDim       = size(nDataSet(nSession).unit_yes_trial, 2)-2;
    load([TempDatDir 'Session_' num2str(nSession) '.mat'],'err_model1','err_model2', 'err_model3', 'err_model4');
    figure;
    Err_all    = 100 - [mean(err_model1');mean(err_model2');mean(err_model3');mean(err_model4')]*100;
    Std_all    = [std(err_model1');std(err_model2');std(err_model3');std(err_model4')]/sqrt(nFold)*100;    
    [maxEV, maxIdx] = max(Err_all(bestModelIdx, :));
%     optIdx     = find(Err_all(bestModelIdx, :)>maxEV*thres, 1, 'first');
    hold on
    errorbar((1:xDim)'*ones(1,4), Err_all',Std_all', '-o','linewid',1)
    xlim([0.5 xDim+1]);
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    yesTrial   = size(nDataSet(nSession).unit_yes_trial, 1);
    noTrial    = size(nDataSet(nSession).unit_no_trial, 1);
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    totTrial   = [true(yesTrial, 1); false(noTrial, 1)];
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    err        = evMean (Y, Ph, timePoint, totTrial)*100;
%     plot([optIdx, maxIdx], [maxEV, maxEV], '+k')
    xlabel('Latent Dimension');
    ylabel('% Exp. Var.');
    gridxy([], [100-err],'Color','k','Linestyle','--')
%     ylim([0 ceil(max(Err_all(:)+Std_all(:)))])
    ylim([0 60])
    hold off
    box off
    set(gca, 'TickDir', 'out')
    setPrint(6, 4.5, ['LDSPlots/LDSModelComparison_Session_' num2str(nSession)])
end