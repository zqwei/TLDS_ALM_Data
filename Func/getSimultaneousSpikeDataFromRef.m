
function newDataSet = getSimultaneousSpikeDataFromRef(nDataSet, refDataSet)
    
    newDataSet      = refDataSet;
    
    numT            = size(nDataSet(1).unit_yes_trial, 2);
    
    for nSession    = 1:length(refDataSet)
        
        [numTrial, numUint, ~] = size(newDataSet(nSession).unit_yes_trial);
        newDataSet(nSession).unit_yes_trial = nan(numTrial, numUint, numT);
        
        for nTrial  = 1:length(newDataSet(nSession).unit_yes_trial_index)
            for mUnit = 1:numUint
                unitIdx = [nDataSet.sessionIndex]==refDataSet(nSession).sessionIndex & ....
                          [nDataSet.nUnit] == refDataSet(nSession).nUnit(mUnit);
                trialIdx = newDataSet(nSession).unit_yes_trial_index(nTrial);
                trialIdx = nDataSet(unitIdx).unit_yes_trial_index == trialIdx;
                newDataSet(nSession).unit_yes_trial(nTrial, mUnit, :) = nDataSet(unitIdx).unit_yes_trial(trialIdx, :);
            end
        end
        
        
        [numTrial, numUint, ~] = size(newDataSet(nSession).unit_no_trial);
        newDataSet(nSession).unit_no_trial = nan(numTrial, numUint, numT);
        
        for nTrial  = 1:length(newDataSet(nSession).unit_no_trial_index)
            for mUnit = 1:numUint
                unitIdx = [nDataSet.sessionIndex]==refDataSet(nSession).sessionIndex & ....
                          [nDataSet.nUnit] == refDataSet(nSession).nUnit(mUnit);
                trialIdx = newDataSet(nSession).unit_no_trial_index(nTrial);
                trialIdx = nDataSet(unitIdx).unit_no_trial_index == trialIdx;
                newDataSet(nSession).unit_no_trial(nTrial, mUnit, :) = nDataSet(unitIdx).unit_no_trial(trialIdx, :);
            end
        end
        
        
    end

