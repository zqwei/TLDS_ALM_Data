addpath('../Func');
setDir;
load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
load([TempDatDir 'Combined_data_SLDS_fit.mat'], 'fitData')

numSession   = length(nDataSet);

explainedCRR = nan(numSession, 7);
explainedVRR = nan(numSession, 7);
%1: mean
%2: edlds fit
%3: lds fit
%4: gpfa
%5: slds 2
%6: slds 4
%7: slds 6


for nSession = 1:numSession
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    Y_s        = permute(Y, [2 3 1]); % unit x time x trial
    numUnit    = size(Y_s, 1);
    Y_s        = reshape(Y_s, numUnit, []);
    mean_y     = mean(mean(Y_s, 2),3);
    rand_y     = sum(bsxfun(@minus, Y_s, mean_y).^2, 2);
    
    % mean
    yes_var    = sum(squeeze(var(nDataSet(nSession).unit_yes_trial, [], 1))*size(nDataSet(nSession).unit_yes_trial, 1), 2);
    no_var     = sum(squeeze(var(nDataSet(nSession).unit_no_trial, [], 1))*size(nDataSet(nSession).unit_no_trial, 1), 2);
    
    explainedCRR(nSession, 1) = 1 - mean((yes_var+no_var)./rand_y);
    explainedVRR(nSession, 1) = std((yes_var+no_var)./rand_y)/sqrt(numUnit);
    
    
    % edlds
    y_est      = [nDataSet(nSession).unit_KF_yes_fit; nDataSet(nSession).unit_KF_no_fit];
    errTrialC  = sum(sum((Y-y_est).^2, 1), 3)./rand_y';
    explainedCRR(nSession, 2) = 1 - mean(errTrialC);
    explainedVRR(nSession, 2) = std(errTrialC)/sqrt(numUnit);
    
    
    % lds
    y_est      = [nDataSet(nSession).unit_CKF_yes_fit; nDataSet(nSession).unit_CKF_no_fit];
    errTrialC  = sum(sum((Y-y_est).^2, 1), 3)./rand_y';
    explainedCRR(nSession, 3) = 1 - mean(errTrialC);
    explainedVRR(nSession, 3) = std(errTrialC)/sqrt(numUnit);
    
    % gpfa
    y_est      = [nDataSet(nSession).unit_GPFA_yes_fit; nDataSet(nSession).unit_GPFA_no_fit];
    errTrialC  = sum(sum((Y-y_est).^2, 1), 3)./rand_y';
    explainedCRR(nSession, 4) = 1 - mean(errTrialC);
    explainedVRR(nSession, 4) = std(errTrialC)/sqrt(numUnit);
    
    %slds 2
    y_est      = fitData(nSession).K2yEst;
    errTrialC  = sum(sum((Y-y_est).^2, 1), 3)./rand_y';
    explainedCRR(nSession, 5) = 1 - mean(errTrialC);
    explainedVRR(nSession, 5) = std(errTrialC)/sqrt(numUnit);
    
    %slds 4
    y_est      = fitData(nSession).K4yEst;
    errTrialC  = sum(sum((Y-y_est).^2, 1), 3)./rand_y';
    explainedCRR(nSession, 6) = 1 - mean(errTrialC);
    explainedVRR(nSession, 6) = std(errTrialC)/sqrt(numUnit);
    
    %slds 8
    y_est      = fitData(nSession).K8yEst;
    errTrialC  = sum(sum((Y-y_est).^2, 1), 3)./rand_y';
    explainedCRR(nSession, 7) = 1 - mean(errTrialC);
    explainedVRR(nSession, 8) = std(errTrialC)/sqrt(numUnit);
    
end


figure;
hold on
plot([-0.05 1], [-0.05 1], '--k');
% plot(explainedCRR(:, 2), explainedCRR(:, [1 2 3 4 5 6 7]), 'o')
% plot(explainedCRR(:, 2), explainedCRR(:, 1), 'ok')
errorbarxy(explainedCRR(:, 2), explainedCRR(:, 1), explainedVRR(:, 2), explainedVRR(:, 1), {'ko', 'k', 'k'})
hold off
xlim([-0.05 0.7])
ylim([-0.05 0.7])
xlabel('EV EDLDS model')
ylabel('EV PSTH')
set(gca, 'TickDir', 'out')
setPrint(8, 6, 'Plots/LDSModelFit_EV_VanillaCorrect_errorbar', 'pdf')

% % for n = 1:7
% %     for m = n+1:7
% %         [p, h] = signrank(explainedCRR(:, n)-explainedCRR(:, m));
% %         disp([n, m, p, h])
% %     end
% % end
% % 
% % figure,
% % hold on
% % boxplot(explainedCRR(:, [3 1 4 5 2 6 7]))
% % box off
% % xlabel('EV TLDS model')
% % ylabel('EV Vanilla model')
% % set(gca, 'TickDir', 'out')
% % setPrint(4, 3, 'Plots/LDSModelFit_EV_box_plot')
