%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DV as a function of time, DV is defined using 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])  


for nSession  = 1:length(nDataSet)

    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    timePoint             = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
    
    figure;
    
    for nTimePoint        = 1:3
        subplot(1, 3, nTimePoint)

        sampleCD              = mean(coeffs(:, timePoint(nTimePoint+1):timePoint(nTimePoint+2)), 2);
        sampleCD              = sampleCD/norm(sampleCD);
        neuralProj            = nan(size(nSessionData, 1), size(nSessionData, 3));
        for nTime             = 1:size(nSessionData, 3)
            neuralProj(:, nTime) = squeeze(nSessionData(:, :, nTime)) * sampleCD;
        end

        hold on
        shadedErrorBar(params.timeSeries, -mean(neuralProj(totTargets, :)), std(neuralProj(totTargets, :)/sqrt(sum(totTargets))), {'-b'})
        shadedErrorBar(params.timeSeries, -mean(neuralProj(~totTargets, :)), std(neuralProj(~totTargets, :)/sqrt(sum(~totTargets))), {'-r'})
        xlim([min(params.timeSeries) max(params.timeSeries)]);
    %     ylim([-6 6]);
        gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
        box off;
        hold off;
        xlabel('LDA Time (s)')
        ylabel('LDA Time (s)')
        set(gca, 'TickDir', 'out')
    end
    setPrint(8*3, 6, ['Plots/SimilarityLDAScore_idx_' num2str(nSession, '%02d')])

end

close all