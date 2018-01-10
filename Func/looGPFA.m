%
% LONO for GPFA data
% 
% This uses the computation from cross-validation in GPFA outputs
%
% @ 2014 Ziqiang Wei
% weiz@janelia.hhmi.org
% 
% 

function [err, y_est, rand_y] = looGPFA (seqTest, xDim) % Leave one neuron out evaluation
    
    % y --- yDim x T x K

    [yDim, T] = size(seqTest(1).y);
    
    K         = length(seqTest);
    
    y         = nan(yDim, T, K);
    y_est     = nan(yDim,T,K);
    
    for nTrial   = 1:K
        y(:, :, nTrial)     = seqTest(nTrial).y;
        y_est_trial         = 0;
%         for nDim = 1:xDim
%             fn          = sprintf('ycsOrth%02d', nDim);
%             y_est_trial = y_est_trial + seqTest(nTrial).(fn);
%         end
        fn          = sprintf('ycsOrth%02d', xDim);
        y_est_trial = y_est_trial + seqTest(nTrial).(fn);
        y_est(:, :, nTrial) = y_est_trial;
    end
    
%     y              = y.^2;
%     y_est(y_est<0) = 0;
%     y_est          = y_est.^2;
    
    mean_y       = mean(mean(y, 3), 2);
    diff_y       = bsxfun(@minus, y, mean_y);
    
    rand_y       = sum(diff_y(:).^2); % all variance needs to explain
    
    err_y        = y - y_est;
    
    
    err = 1 - sum(err_y(:).^2)/rand_y;