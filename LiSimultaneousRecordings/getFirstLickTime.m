addpath('../Func');
setDir;
load([TempDatDir 'Simultaneous_Spikes.mat'])
numSession   = length(nDataSet);

for nSession = 1:numSession
    load([SpikingDataDir SpikeFileList(nDataSet(nSession).sessionIndex).name])
    numYesTrial = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial  = length(nDataSet(nSession).unit_no_trial_index);
    totTargets = [true(numYesTrial, 1); false(numNoTrial, 1)];
    firstLickTime = nan(size(totTargets));
    for nTrial = 1:numYesTrial
        ntrial_index = nDataSet(nSession).unit_yes_trial_index(nTrial);
        ntrial_firstLick = behavior_lick_times{ntrial_index};
        ntrial_firstLick = ntrial_firstLick - task_cue_time(ntrial_index);
        ntrial_firstLick(ntrial_firstLick<0) = [];
        ntrial_firstLick = min(ntrial_firstLick) * 1000;
        firstLickTime(nTrial) = ntrial_firstLick;
    end
    
    for nTrial = 1:numNoTrial
        ntrial_index = nDataSet(nSession).unit_no_trial_index(nTrial);
        ntrial_firstLick = behavior_lick_times{ntrial_index};
        ntrial_firstLick = ntrial_firstLick - task_cue_time(ntrial_index);
        ntrial_firstLick(ntrial_firstLick<0) = [];
        ntrial_firstLick = min(ntrial_firstLick) * 1000;
        firstLickTime(numYesTrial+nTrial) = ntrial_firstLick;
    end    
    nDataSet(nSession).totTargets = totTargets;
    nDataSet(nSession).firstLickTime = firstLickTime;
end

save([TempDatDir 'Simultaneous_Spikes.mat'], 'nDataSet', 'kickOutIndex', 'params', 'ActiveNeuronIndex');