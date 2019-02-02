%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate behavioral performance data based on simultaneous recordings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;

load([TempDatDir 'Simultaneous_Spikes.mat']);

numSpike1  = length(SpikeFileList);

nBehaviors = repmat(struct('behavior_early_report',1, 'behavior_report', 1, ...
                                'task_stimulation', 1),length(nDataSet), 1);

for nBeh   = 1:length(nDataSet)
    session_ = nDataSet(nBeh).sessionIndex;
    if session_ < numSpike1
        fname               = SpikeFileList(session_).name;
        load([SpikingDataDir fname])
        nBehaviors(nBeh).behavior_early_report = behavior_early_report;
        nBehaviors(nBeh).task_stimulation      = task_stimulation;
        nBehaviors(nBeh).behavior_report       = behavior_report;
        nBehaviors(nBeh).task_trial_type       = task_trial_type =='y';
    else
        session_ = session_ - numSpike1;
        fname               = SpikeFileList2(session_).name;
        load([SpikingDataDir2 fname])
        nBehaviors(nBeh).behavior_early_report = behavior_early_report;
        nBehaviors(nBeh).task_stimulation      = task_stimulation;
        nBehaviors(nBeh).behavior_report       = behavior_report;
        nBehaviors(nBeh).task_trial_type       = task_trial_type =='y';
    end
end

save([TempDatDir 'Behavior_Simultaneous_Spikes.mat'], 'nBehaviors');