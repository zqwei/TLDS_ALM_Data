addpath('../Func');
setDir;
firstLickTimeSet = [];

for nSession = 1:length(SpikeHiFileList)+length(SpikeHiFileList2)
    if nSession <= length(SpikeHiFileList)
        load([SpikingHiDir SpikeHiFileList(nSession).name])
    else
        load([SpikingHiDir2 SpikeHiFileList2(nSession - length(SpikeHiFileList)).name])
    end
    behavior_report     = unit(1).Behavior.Trial_types_of_response_vector;
    task_stimulation    = unit(1).Behavior.stim_trial_vector;
    valid_trials = (behavior_report== 1 | behavior_report== 2) & (task_stimulation(:,1)==0);
    firstLickTime = unit(1).Behavior.First_lick - unit(1).Behavior.Cue_start;
    firstLickTime = firstLickTime(valid_trials)*1000;
    firstLickTimeSet = [firstLickTimeSet, firstLickTime];
end
% subplot(1, 2, 1)
% hist(firstLickTimeSet, 100);
% xlabel('first lick time')
% ylabel('# trials')
% title('hidehiko data')
% 
% firstLickTimeSet = [];
% addpath('../Func');
% setDir;

for nSession = 1:length(SpikeFileList)
    load([SpikingDataDir SpikeFileList(nSession).name])
    valid_trial   = ~behavior_early_report & (behavior_report== 1) & (task_stimulation(:,1)==0);
    firstLickTime = nan(1, length(behavior_early_report));
    for nTrial = find(valid_trial)'
        ntrial_index = nTrial;
        ntrial_firstLick = behavior_lick_times{ntrial_index};
        ntrial_firstLick = ntrial_firstLick - task_cue_time(ntrial_index);
        ntrial_firstLick(ntrial_firstLick<0) = [];
        ntrial_firstLick = min(ntrial_firstLick) * 1000;
        firstLickTime(nTrial) = ntrial_firstLick;
    end
    
    firstLickTimeSet = [firstLickTimeSet, firstLickTime];

end

% subplot(1, 2, 2)
hist(firstLickTimeSet, 0:15:900);
xlim([0 600])
xlabel('first lick time')
ylabel('# trials')
box off
set(gca, 'TickDir', 'out')
setPrint(8, 6, 'RT_distribution')