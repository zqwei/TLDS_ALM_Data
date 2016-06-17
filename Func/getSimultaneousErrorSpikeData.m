
function errorDataSet  = getSimultaneousErrorSpikeData(nDataSet, mDataSet, SpikingHiDir, SpikeHiFileList)
    errorDataSet       = nDataSet;
    for nSession       = 1:length(nDataSet)
        numUnit        = length(errorDataSet(nSession).nUnit);
        numT           = size(errorDataSet(nSession).unit_yes_trial, 3);
        trialList      = cell(numUnit, 1);
        
        %%% yes
        for nUnit      = 1:numUnit
            mUnit      = [mDataSet.sessionIndex]==errorDataSet(nSession).sessionIndex & ...
                         [mDataSet.nUnit]==errorDataSet(nSession).nUnit(nUnit);
            trialList{nUnit} = mDataSet(mUnit).unit_yes_error_index;
        end 
        
        intSect       = interSection(trialList);
        
        if ~isempty(intSect)
            errorDataSet(nSession).unit_yes_trial_index = intSect;
            unit_yes_trial                              = nan(length(intSect), numUnit, numT);
            firstLickTime                               = nan(length(intSect), 1);
            
            for nIntSect = 1:length(intSect)
                for nUnit = 1:numUnit
                    mUnit      = [mDataSet.sessionIndex]==errorDataSet(nSession).sessionIndex & ...
                                 [mDataSet.nUnit]==errorDataSet(nSession).nUnit(nUnit);
                    unit_yes_trial(nIntSect, nUnit, :)  = mDataSet(mUnit).unit_yes_error(mDataSet(mUnit).unit_yes_error_index==intSect(nIntSect), :);
                end
                load([SpikingHiDir SpikeHiFileList(nDataSet(nSession).sessionIndex).name])
                ntrial_index = intSect(nIntSect);
                ntrial_firstLick = unit(1).Behavior.First_lick(ntrial_index);
                ntrial_firstLick = ntrial_firstLick - unit(1).Behavior.Cue_start(ntrial_index);
                ntrial_firstLick(ntrial_firstLick<0) = [];
                ntrial_firstLick = min(ntrial_firstLick) * 1000;
                firstLickTime(nIntSect) = ntrial_firstLick;
            end
            
            errorDataSet(nSession).unit_yes_trial       = unit_yes_trial;
            errorDataSet(nSession).totTargets           = true(length(intSect), 1);
            errorDataSet(nSession).firstLickTime        = firstLickTime;            
        else
            errorDataSet(nSession).unit_yes_trial_index = [];
            errorDataSet(nSession).unit_yes_trial       = [];
            errorDataSet(nSession).totTargets           = [];
            errorDataSet(nSession).firstLickTime        = [];
        end
        
        %%% no
        for nUnit      = 1:numUnit
            mUnit      = [mDataSet.sessionIndex]==errorDataSet(nSession).sessionIndex & ...
                         [mDataSet.nUnit]==errorDataSet(nSession).nUnit(nUnit);
            trialList{nUnit} = mDataSet(mUnit).unit_no_error_index;
        end 
        
        intSect       = interSection(trialList);
        
        if ~isempty(intSect)
            errorDataSet(nSession).unit_no_trial_index  = intSect;
            unit_no_trial                               = nan(length(intSect), numUnit, numT);
            firstLickTime                               = nan(length(intSect), 1);
            
            for nIntSect = 1:length(intSect)
                for nUnit = 1:numUnit
                    mUnit      = [mDataSet.sessionIndex]==errorDataSet(nSession).sessionIndex & ...
                                 [mDataSet.nUnit]==errorDataSet(nSession).nUnit(nUnit);
                    unit_no_trial(nIntSect, nUnit, :)  = mDataSet(mUnit).unit_no_error(mDataSet(mUnit).unit_no_error_index==intSect(nIntSect), :);
                end
                load([SpikingHiDir SpikeHiFileList(nDataSet(nSession).sessionIndex).name])
                ntrial_index = intSect(nIntSect);
                ntrial_firstLick = unit(1).Behavior.First_lick(ntrial_index);
                ntrial_firstLick = ntrial_firstLick - unit(1).Behavior.Cue_start(ntrial_index);
                ntrial_firstLick(ntrial_firstLick<0) = [];
                ntrial_firstLick = min(ntrial_firstLick) * 1000;
                firstLickTime(nIntSect) = ntrial_firstLick;
            end
            
            errorDataSet(nSession).unit_no_trial        = unit_no_trial;
            errorDataSet(nSession).totTargets           = [errorDataSet(nSession).totTargets; false(length(intSect), 1)];
            errorDataSet(nSession).firstLickTime        = [errorDataSet(nSession).firstLickTime; firstLickTime];            
        else
            errorDataSet(nSession).unit_no_trial_index  = [];
            errorDataSet(nSession).unit_no_trial        = [];
        end        
        
    end
end

function intSect       = interSection(trialList)
    intSect            = intersect(trialList{1}, trialList{2});
    if length(trialList)>2
        for nUnit      = 3:length(trialList)
            intSect    = intersect(trialList{nUnit}, intSect);
        end
    end
end