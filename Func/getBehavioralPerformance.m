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



function CR = getBehavioralPerformance(SpikingDataDir, SpikeFileList)
    
    CR      = zeros(length(SpikeFileList), 2);
        
    for nfile = 1:length(SpikeFileList)
        fname               = SpikeFileList(nfile).name;
        load([SpikingDataDir fname])
        valid_trials = (~behavior_early_report) & (behavior_report== 1) & ...
                        (task_stimulation(:,1)==0);  %#ok<NODEF>                    
        valid_errors = (~behavior_early_report) & (behavior_report== 0) & ...
                        (task_stimulation(:,1)==0);  
        task_type    = task_trial_type =='y';
        valid_all    = valid_trials | valid_errors;        
        CR(nfile, 1) = sum(task_type & valid_trials) / sum(task_type & valid_all);
        CR(nfile, 2) = sum(~task_type & valid_trials) / sum(~task_type & valid_all);
    end
end
    