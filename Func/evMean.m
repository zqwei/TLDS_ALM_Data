%
% 
% Estimation error from mean
%
% Inputs:
% 
% y     -- observed data
%
%
% Output:
% 
% err    -- sum squared estimation error
%
%
%
% Ver: 1.0
%
% @ 2014 Ziqiang Wei
% weiz@janelia.hhmi.org
% 
% 

function err = evMean (y, Ph, timePoint, totTrial) % Leave one neuron out evaluation
    
    % y --- yDim x T x K

    [yDim, T, K] = size(y);
    
    d            = Ph.d;
    
    if size(d,1) ~= yDim
        d        = ones(yDim,1) * d;
    end
    
    nt           = length(timePoint) - 1;
    for nt_now   = 1:nt
        y(:,timePoint(nt_now)+1:timePoint(nt_now+1),:) = ...
            remove_mean(y(:,timePoint(nt_now)+1:timePoint(nt_now+1),:),d(:,nt_now));
    end
    
    rand_y       = sum(y(:).^2); % all variance needs to explain
    err          = 0;
    
    for nUnit    = 1:yDim
        y_n      = squeeze(y(nUnit,:,:));
        meanYes  = mean(y_n(:, totTrial), 2);
        errYes   = bsxfun(@minus, y_n(:, totTrial), meanYes);
        errYes   = sum(errYes(:).^2);
        meanNo   = mean(y_n(:, ~totTrial), 2);
        errNo    = bsxfun(@minus, y_n(:, ~totTrial), meanNo);
        errNo    = sum(errNo(:).^2);
        
        err      = err + errYes + errNo;
        
    end
    
    err          = err/rand_y;