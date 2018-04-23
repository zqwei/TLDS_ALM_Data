%
% shuffleSessionData.m
%
%
% ----------------------------
% Output:
%
% version 1.0
%
% -------------------------------------------------------------------------
% Ziqiang Wei
% weiz@janelia.hhmi.org
% 

function nSessionData = shuffleSession(nDataSet, numShfTrials)
    
    numUnits          = length(nDataSet.nUnit);
    T                 = size(nDataSet.unit_yes_trial, 3);
    totTargets        = nDataSet.totTargets;
    numYes            = sum(totTargets);
    numNo             = sum(~totTargets);
    nSessionData      = zeros(numShfTrials, numUnits, T);
    
    
    for nTrial        = 1:numShfTrials
        randMat       = randperm(numYes, numUnits);
        for nUnit     = 1:numUnits
            nSessionData(nTrial, nUnit, :) = nDataSet.unit_yes_trial(randMat(nUnit), nUnit, :);
        end
    end
    
    for nTrial        = 1:numShfTrials
        randMat       = randperm(numNo, numUnits);
        for nUnit     = 1:numUnits
            nSessionData(nTrial+numShfTrials, nUnit, :) = nDataSet.unit_no_trial(randMat(nUnit), nUnit, :);
        end
    end
    
end
