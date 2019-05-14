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

function nSessionData = shuffleSessionEpoch(nDataSet, numShfTrials, timePoints)
    
    numUnits          = length(nDataSet.nUnit);
    T                 = size(nDataSet.unit_yes_trial, 3);
    totTargets        = nDataSet.totTargets;
    numYes            = sum(totTargets);
    numNo             = sum(~totTargets);
    nSessionData      = zeros(numShfTrials, numUnits, T);
    
    
    for nTrial        = 1:numShfTrials
        for nEpoch    = 1:length(timePoints)-1
            randMat       = randperm(numYes, numUnits);
            for nUnit     = 1:numUnits
                nSessionData(nTrial, nUnit, timePoints(nEpoch)+1:timePoints(nEpoch+1)) = ...
                    nDataSet.unit_yes_trial(randMat(nUnit), nUnit, timePoints(nEpoch)+1:timePoints(nEpoch+1));
            end
        end
    end
    
    for nTrial        = 1:numShfTrials
        for nEpoch    = 1:length(timePoints)-1
            randMat       = randperm(numNo, numUnits);
            for nUnit     = 1:numUnits
                nSessionData(nTrial+numShfTrials, nUnit, timePoints(nEpoch)+1:timePoints(nEpoch+1)) = ...
                    nDataSet.unit_no_trial(randMat(nUnit), nUnit, timePoints(nEpoch)+1:timePoints(nEpoch+1));
            end
        end
    end
    
end