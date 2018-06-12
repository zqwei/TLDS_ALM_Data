addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Error_Spikes.mat'])
errDataSet  = nDataSet;
load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
corrDataSet  = nDataSet;


cmap                = cbrewer('div', 'Spectral', 128, 'cubic');
param               = params(nDataSet(1).task_type);
sigma               = 0.15 / param.binsize; % 300 ms
filterLength        = 11;
filterStep          = linspace(-filterLength / 2, filterLength / 2, filterLength);
filterInUse         = exp(-filterStep .^ 2 / (2 * sigma ^ 2));
filterInUse         = filterInUse / sum (filterInUse); 


for nSession = [13 14 17 25 28 33]
    param         = params(nDataSet(nSession).task_type);
    figure
    
    numCYes       = length(corrDataSet(nSession).unit_yes_trial_index);
    numCNo        = length(corrDataSet(nSession).unit_no_trial_index);
    
    numEYes       = length(errDataSet(nSession).unit_yes_trial_index);
    numENo        = length(errDataSet(nSession).unit_no_trial_index);
    
    % SVM
    subplot(1,2,1)
    nSessionData  = [corrDataSet(nSession).unit_KF_yes_fit(1:ceil(numCYes/2), :, :); corrDataSet(nSession).unit_KF_no_fit(1:ceil(numCNo/2), :, :)];
    totTrialC     = size(nSessionData, 1);
    nSessionData  = [nSessionData; errDataSet(nSession).unit_KF_yes_fit(1:ceil(numEYes/2), :, :); errDataSet(nSession).unit_KF_no_fit(1:ceil(numEYes/2), :, :)];
    totTrialE     = size(nSessionData, 1) - totTrialC;
    totTargets    = [true(totTrialC, 1); false(totTrialE, 1)];
    nSessionData  = normalizationDim(nSessionData, 2);
    correctRate   = coeffSVM(nSessionData, totTargets); 
    hold on
    shadedErrorBar(param.timeSeries, getGaussianPSTH(filterInUse, correctRate(1,:),2),correctRate(2,:),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);

    nSessionData  = [corrDataSet(nSession).unit_yes_trial(1:ceil(numCYes/2), :, :); corrDataSet(nSession).unit_no_trial(1:ceil(numCNo/2), :, :)];
    nSessionData  = [nSessionData; errDataSet(nSession).unit_yes_trial(1:ceil(numEYes/2), :, :); errDataSet(nSession).unit_no_trial(1:ceil(numEYes/2), :, :)];
    nSessionData  = normalizationDim(nSessionData, 2);  
    correctRate   = coeffSVM(nSessionData, totTargets);  
    hold on
    shadedErrorBar(param.timeSeries, getGaussianPSTH(filterInUse, correctRate(1,:),2),correctRate(2,:),{'-k','linewid',1},0.5);
    ylim([0.4 1.01])
    gridxy ([param.polein, param.poleout, 0],[0.5], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('Decodability of reward')
    set(gca, 'TickDir', 'out')
    
    
    % SVM
    subplot(1,2,2) % reproduce of figure 5e
    nSessionData  = [corrDataSet(nSession).unit_KF_yes_fit(ceil(numCYes/2):end, :, :); corrDataSet(nSession).unit_KF_no_fit(ceil(numCNo/2):end, :, :)];
    totTrialC     = size(nSessionData, 1);
    nSessionData  = [nSessionData; errDataSet(nSession).unit_KF_yes_fit(ceil(numEYes/2):end, :, :); errDataSet(nSession).unit_KF_no_fit(ceil(numEYes/2):end, :, :)];
    totTrialE     = size(nSessionData, 1) - totTrialC;
    totTargets    = [true(totTrialC, 1); false(totTrialE, 1)];
    nSessionData  = normalizationDim(nSessionData, 2);
    correctRate   = coeffSVM(nSessionData, totTargets); 
    hold on
    shadedErrorBar(param.timeSeries, getGaussianPSTH(filterInUse, correctRate(1,:),2),correctRate(2,:),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);

    nSessionData  = [corrDataSet(nSession).unit_yes_trial(ceil(numCYes/2):end, :, :); corrDataSet(nSession).unit_no_trial(ceil(numCNo/2):end, :, :)];
    nSessionData  = [nSessionData; errDataSet(nSession).unit_yes_trial(ceil(numEYes/2):end, :, :); errDataSet(nSession).unit_no_trial(ceil(numEYes/2):end, :, :)];
    nSessionData  = normalizationDim(nSessionData, 2);  
    correctRate   = coeffSVM(nSessionData, totTargets);  
    hold on
    shadedErrorBar(param.timeSeries, getGaussianPSTH(filterInUse, correctRate(1,:),2),correctRate(2,:),{'-k','linewid',1},0.5);
    ylim([0.4 1.01])
    gridxy ([param.polein, param.poleout, 0],[0.5], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('Decodability of reward')
    set(gca, 'TickDir', 'out')
    

    
    setPrint(8*2, 6*1, ['Plots/Error_Trial_Half_Session_idx_' num2str(nSession)])
    close all
end

