addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_HiSoundSpikes.mat'])
mean_type    = 'Constant_mean';
tol          = 1e-3;
cyc          = 10000;
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
nFold        = 10;

for nSession = 1:numSession
    
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    Y          = permute(Y, [2 3 1]);
    xDim       = size(Y,1)-2;
    
    err_model1 = cross_valid_ldsi_uni(Y, xDim, nFold, timePoint, 'mean_type',mean_type,'tol',tol,'cyc',cyc,'is_fix_C',true,'is_fix_A',true);
    err_model2 = cross_valid_ldsi_uni(Y, xDim, nFold, timePoint, 'mean_type',mean_type,'tol',tol,'cyc',cyc,'is_fix_C',false,'is_fix_A',true);
    err_model3 = cross_valid_ldsi_uni(Y, xDim, nFold, timePoint, 'mean_type',mean_type,'tol',tol,'cyc',cyc,'is_fix_C',true,'is_fix_A',false);
    err_model4 = cross_valid_ldsi_uni(Y, xDim, nFold, timePoint, 'mean_type',mean_type,'tol',tol,'cyc',cyc,'is_fix_C',false,'is_fix_A',false);

    save([TempDatDir 'SessionHiSound_' num2str(nSession) '.mat'],'err_model1','err_model2', 'err_model3', 'err_model4');
    
    figure;
    Err_all    = 100 - [mean(err_model1');mean(err_model2');mean(err_model3');mean(err_model4')]*100;
    Std_all    = [std(err_model1');std(err_model2');std(err_model3');std(err_model4')]/sqrt(nFold)*100;
    errorbar((1:xDim)'*ones(1,4), Err_all',Std_all', '-o','linewid',1)
    % plot(1:xDim, Err_all')
    xlabel('Latent Dimension');
    ylabel('% Exp. Var.');
    xlim([0.5 xDim+1]);
    ylim([0 ceil(max(Err_all(:)+Std_all(:)))])
    box off
    setPrint(6, 4.5, ['LDSPlots/LDSModelComparison_Session_' num2str(nSession)])
end