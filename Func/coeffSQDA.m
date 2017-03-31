%
% coeffSLDA.m
%
%
% ----------------------------
% Output:
%
% version 2.0
%
% based on paper:
%
% Guo et al., Biostatistics, 2007
%
% -------------------------------------------------------------------------
% Ziqiang Wei
% weiz@janelia.hhmi.org
% 

function [correctRate] = coeffSQDA(nSessionData, totTargets)
    
    T                        = size(nSessionData, 3);

    coeffGammaDeltaErrs      = arrayfun(@(tIndex) coeffClassify(...
                                           squeeze(nSessionData(:,:,tIndex)), ...
                                           totTargets), 1:T, 'UniformOutput', false);
                                       
    coeffGammaDeltaErrs      = cell2mat(coeffGammaDeltaErrs);
    correctRate              = coeffGammaDeltaErrs;
    
end


function coeffGammaDeltaErr  = coeffClassify(nSessionData, totTargets)
    
    
    % choice of parameters follows 'min-min' rul in Guo's paper
    % Here we only consider to use a Gamma which is close enough to zero
    
    zeroVarUnits           = var(nSessionData, 1) < 1e-5;
%     coeffLength            = size(nSessionData, 2);
    nSessionData           = nSessionData(:, ~zeroVarUnits);
    
    Mdl                    = fitcdiscr(nSessionData, totTargets, ...
                                'DiscrimType', 'pseudoquadratic',... 
                                'SaveMemory', 'on', 'FillCoeffs','off', ...
                                'Prior', 'empirical');
% % % %     disp(Mdl.MinGamma)
% % %                         
% % %     if size(nSessionData,1) < size(nSessionData,2)                   
% % %         [err, gamma, delta, ~] = cvshrink(Mdl, 'NumGamma', 10, ...
% % %                                 'NumDelta', 100, 'Verbose', 0);                         
% % %         % min-min error rule
% % %         minerr                 = min(min(err));
% % %         [p, q]                 = find(err == minerr);
% % %         idx                    = sub2ind(size(delta), p, q);    
% % %         gammaDeltaSet          = [gamma(p) delta(idx)];
% % %         gammaDeltaSet          = gammaDeltaSet(gammaDeltaSet(:, 2)...
% % %                                     == max(gammaDeltaSet(:, 2)),:);
% % %         gammaDeltaSet          = gammaDeltaSet(gammaDeltaSet(:, 1)...
% % %                                     == min(gammaDeltaSet(:, 1)),:);
% % %     else
% % %         [err, gamma, ~]        = cvshrink(Mdl, 'NumGamma', 10, ...
% % %                                 'Verbose', 0);                         
% % %         % min-min error rule
% % %         minerr                 = min(min(err));
% % %         gammaDeltaSet          = gamma(err == minerr);
% % %         gammaDeltaSet          = gammaDeltaSet(gammaDeltaSet(:, 1)...
% % %                                     == min(gammaDeltaSet(:, 1)),:);
% % %         gammaDeltaSet          = [gammaDeltaSet(1), 0];
% % %     end
        
% % %     obj                        = fitcdiscr(nSessionData, totTargets, ...
% % %                                     'DiscrimType', 'pseudoquadratic',...         
% % %                                     'Delta', gammaDeltaSet(2), ...
% % %                                     'Gamma', gammaDeltaSet(1));
    
% % %     cvmodel                = crossval(obj, 'KFold', 5);
    cvmodel                = crossval(Mdl, 'KFold', 5);
    
    coeffGammaDeltaErr     = 1 - kfoldLoss(cvmodel);
        
end