addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_Spikes.mat'])
load([TempDatDir 'Simultaneous_Spikes_SLDS_EV.mat'])
mean_type    = 'Constant_mean';
tol          = 1e-3;
cyc          = 10000;
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
nFold        = 10;
% bestModelIdx = 4;
% thres        = 0.8;

GPFAresultsFolder = '/Volumes/My Drive/ALM_Recording_Pole_Task_Svoboda_Lab/TLDS_analysis_Li_data/GPFA_Li_Data/mat_results/';

for nSession = [17 20]
    xDim       = size(nDataSet(nSession).unit_yes_trial, 2)-2;
    figure;
    hold on

    % LDS
    load([TempDatDir 'Session_' num2str(nSession) '.mat'],'err_model1','err_model2', 'err_model3', 'err_model4');    
    Err_all    = 100 - [mean(err_model1');mean(err_model2');mean(err_model3');mean(err_model4')]*100;
    Std_all    = [std(err_model1');std(err_model2');std(err_model3');std(err_model4')]/sqrt(nFold)*100;    
%     Err_all    = 100 - [mean(err_model1');mean(err_model4')]*100;
%     Std_all    = [std(err_model1');std(err_model4')]/sqrt(nFold)*100;        
    errorbar((1:xDim)'*ones(1,4), Err_all',Std_all', '-o','linewid',1)
        
    % GPFA
    GPFAErr    = nan(nFold, xDim);
    for nDim   = 1:xDim
        nfolder = [GPFAresultsFolder, 'run', num2str(nSession, '%03d'), '/gpfa_xDim', num2str(nDim, '%02d'), '_cv'];
        for nCV    = 1:nFold
            nfile  = [nfolder, num2str(nCV, '%02d'), '.mat'];
            load(nfile, 'seqTest');
            [GPFAErr(nCV, nDim), ~, ~] = looGPFA(seqTest, nDim);
            clear seqTest
        end
    end
    GPFAErr    = GPFAErr * 100;
    errorbar(1:xDim, mean(GPFAErr), std(GPFAErr), '-o','linewid',1)
    
    % mean
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    Y_s        = permute(Y, [2 3 1]); % unit x time x trial
    numUnit    = size(Y_s, 1);
    Y_s        = reshape(Y_s, numUnit, []);
    mean_y     = mean(mean(Y_s, 2),3);
    rand_y     = sum(remove_mean(Y_s, mean_y).^2, 2);
    yes_var    = sum(squeeze(var(nDataSet(nSession).unit_yes_trial, [], 1))*size(nDataSet(nSession).unit_yes_trial, 1), 2);
    no_var     = sum(squeeze(var(nDataSet(nSession).unit_no_trial, [], 1))*size(nDataSet(nSession).unit_no_trial, 1), 2);
    err        = mean((yes_var+no_var)./rand_y)*100;
    gridxy([], 100-err,'Color','k','Linestyle','--')
    
    % slds2 4 8
    Err_all    = mean(EVData(nSession).K2EV, 2)*100;
    Std_all    = std(EVData(nSession).K2EV, [], 2)*100;
    errorbar((0:xDim+1)', Err_all',Std_all', '-ok','linewid',1)
    
    Err_all    = mean(EVData(nSession).K4EV, 2)*100;
    Std_all    = std(EVData(nSession).K4EV, [], 2)*100;
    errorbar((0:xDim+1)', Err_all',Std_all', '-ob','linewid',1)
    
    Err_all    = mean(EVData(nSession).K8EV, 2)*100;
    Std_all    = std(EVData(nSession).K8EV, [], 2)*100;
    errorbar((0:xDim+1)', Err_all',Std_all', '-or','linewid',1)

    
%     xlim([0.5 xDim+1]);
%     y_ax       = ylim;
%     y_ax(2)    = ceil(y_ax(2)/10)*10;
    ylim([0 60])
    hold off
    box off
    xlabel('Latent Dimension');
    ylabel('% Exp. Var.');
    set(gca, 'TickDir', 'out')

    setPrint(12, 9, ['LDSPlots/LDSModelComparison_Session_' num2str(nSession)], 'pdf')
end