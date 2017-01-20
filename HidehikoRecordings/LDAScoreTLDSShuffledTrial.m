%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DV as a function of time, DV is defined using 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_HiSpikes.mat']) 

timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [3, 3, 4, 3, 3, 5, 5, 4, 4, 4, 4];
optFitSets   = [4, 25, 7, 20, 8, 10, 1, 14, 15, 10, 15];


for nSession  = 3%1:length(nDataSet)

    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    
    Y             = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    Y             = permute(Y, [2 3 1]);
    yDim          = size(Y, 1);
    T             = size(Y, 2);
    xDim       = xDimSet(nSession);
    optFit     = optFitSets(nSession);
    load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [x_est, y_est] = kfilter (Y, Ph, [0, timePoint, T]);
    
    
    
    nSessionData  = permute(x_est, [3 1 2]);
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    timePoints    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
    
    figure;
    
    for nTimePoint        = 1:3
        subplot(1, 3, nTimePoint)

        sampleCD              = mean(coeffs(:, timePoints(nTimePoint+1):timePoints(nTimePoint+2)), 2);
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
    setPrint(8*3, 6, ['Plots/SimilarityTLDSLDAScore_idx_' num2str(nSession, '%02d')])

end

close all