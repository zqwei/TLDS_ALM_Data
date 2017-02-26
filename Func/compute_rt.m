function [contra_corr, ipsi_corr, contra_rtVar, ipsi_rtVar] = compute_rt(y_est, totTargets, firstLickTime, timePoint)

    nSessionData  = y_est;
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(size(nSessionData, 1), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end

    [contra_corr(1), ~, contra_corr(2), contra_corr(3)] =  ...
        corr_mode(mean(scoreMat(totTargets, timePoint(end)), 2), firstLickTime(totTargets), 'Spearman');
    [ipsi_corr(1), ~, ipsi_corr(2), ipsi_corr(3)] =  ...
        corr_mode(mean(scoreMat(~totTargets, timePoint(end)), 2), firstLickTime(~totTargets), 'Spearman');
    contra_rtVar = std(firstLickTime(totTargets));
    ipsi_rtVar   = std(firstLickTime(~totTargets)); 