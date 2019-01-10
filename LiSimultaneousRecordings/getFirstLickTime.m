addpath('../Func');
setDir;
load([TempDatDir 'Simultaneous_Spikes.mat'])
numSession   = length(nDataSet);

for nSession = 1:numSession
    if nDataSet(nSession).sessionIndex <= length(SpikeFileList)
        load([SpikingDataDir SpikeFileList(nDataSet(nSession).sessionIndex).name])
    else
        load([SpikingDataDir2 SpikeFileList2(nDataSet(nSession).sessionIndex - length(SpikeFileList)).name])
    end
    numYesTrial = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial  = length(nDataSet(nSession).unit_no_trial_index);
    totTargets = [true(numYesTrial, 1); false(numNoTrial, 1)];
    firstLickTime = nan(size(totTargets));
    for nTrial = 1:numYesTrial
        ntrial_index = nDataSet(nSession).unit_yes_trial_index(nTrial);
        ntrial_firstLick = behavior_lick_times{ntrial_index};
        if ~isempty(ntrial_firstLick)
            ntrial_firstLick = ntrial_firstLick(:,1) - task_cue_time(ntrial_index);
            ntrial_firstLick(ntrial_firstLick<0) = [];
            if ~isempty(ntrial_firstLick)
                ntrial_firstLick = min(ntrial_firstLick) * 1000;
                firstLickTime(nTrial) = ntrial_firstLick;
            else
                disp([nSession, ntrial_index])
            end
        else
            disp([nSession, ntrial_index])
        end
    end

    for nTrial = 1:numNoTrial
        ntrial_index = nDataSet(nSession).unit_no_trial_index(nTrial);
        ntrial_firstLick = behavior_lick_times{ntrial_index};
        if ~isempty(ntrial_firstLick)
            ntrial_firstLick = ntrial_firstLick(:,1) - task_cue_time(ntrial_index);
            ntrial_firstLick(ntrial_firstLick<0) = [];
            if ~isempty(ntrial_firstLick)
                ntrial_firstLick = min(ntrial_firstLick) * 1000;
                firstLickTime(numYesTrial+nTrial) = ntrial_firstLick;
            else
                disp([nSession, ntrial_index])
            end
        else
            disp([nSession, ntrial_index])
        end
    end
    nDataSet(nSession).totTargets = totTargets;
    nDataSet(nSession).firstLickTime = firstLickTime;
end

save([TempDatDir 'Simultaneous_Spikes.mat'], 'nDataSet', 'kickOutIndex', 'params', 'ActiveNeuronIndex');
