%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate behavioral performance data based on simultaneous recordings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;

load([TempDatDir 'Simultaneous_HiSoundSpikes.mat']);

nBehaviors = repmat(struct('behavior_early_report',1, 'behavior_report', 1, ...
                                'task_stimulation', 1),length(nDataSet), 1);

for nBeh   = 1:length(nDataSet)
    session_ = nDataSet(nBeh).sessionIndex;
    fname               = SpikeHiSoundFileList(session_).name;
    load([SpikingHiSoundDir fname])
    behavior_report     = unit(1).Behavior.Trial_types_of_response_vector;
    nBehaviors(nBeh).behavior_early_report = behavior_report>4;
    nBehaviors(nBeh).task_stimulation      = unit(1).Behavior.stim_trial_vector;
    nBehaviors(nBeh).behavior_report       = behavior_report<3;
    nBehaviors(nBeh).task_trial_type       = mod(behavior_report, 2)==1;
end

save([TempDatDir 'Behavior_Simultaneous_HiSoundSpikes.mat'], 'nBehaviors');