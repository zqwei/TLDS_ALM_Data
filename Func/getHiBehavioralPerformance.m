% 
% obtain the behavioral performance from a list of files
% 
% version 1.0
%
% Comparison list
%
% Output:
% SpikeDataSet     --- yDim x 1 cells (yDims number of neurons) 
%
% -------------------------------------------------------------------------
% Ziqiang Wei
% weiz@janelia.hhmi.org
% 



function CR = getHiBehavioralPerformance(SpikingDataDir, SpikeFileList)
    
    CR      = zeros(length(SpikeFileList), 2);
    
    for nfile = 1:length(SpikeFileList)
%         if nfile == 25; keyboard(); end
        fname               = SpikeFileList(nfile).name;
        load([SpikingDataDir fname])
        behavior_report     = unit(1).Behavior.Trial_types_of_response_vector;
        task_stimulation    = unit(1).Behavior.stim_trial_vector;
        task_cue_time       = unit(1).Behavior.Cue_start;
        valid_trials = (behavior_report== 1 | behavior_report== 2) & ...
                        (task_stimulation(:,1)==0);
                    
        valid_errors = (behavior_report== 3 | behavior_report== 4) & ...
                        (task_stimulation(:,1)==0);  
        task_type    = mod(behavior_report, 2)==1;
        
        valid_all    = valid_trials | valid_errors;        
        CR(nfile, 1) = sum(task_type & valid_trials) / sum(task_type & valid_all);
        CR(nfile, 2) = sum(~task_type & valid_trials) / sum(~task_type & valid_all);
        
    end