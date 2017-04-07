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
    nSessionData           = nSessionData(:, ~zeroVarUnits);
    
    costFun                = [0, 1; sum(~totTargets)/sum(totTargets), 0];
    
    Mdl                    = fitcdiscr(nSessionData, totTargets, ...
                                'DiscrimType', 'pseudoquadratic',... 
                                'SaveMemory', 'on', 'FillCoeffs','off', ...
                                'Prior', 'empirical', 'Cost', costFun);
                            
    numFold                = 10;
    cvmodel                = crossval(Mdl, 'KFold', numFold);
    kLoss                  = kfoldLoss(cvmodel, 'Mode', 'individual');
    
    coeffGammaDeltaErr     = [1 - mean(kLoss); std(kLoss)/sqrt(numFold)];
        
end