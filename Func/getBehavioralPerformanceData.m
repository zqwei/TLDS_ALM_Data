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



function PFData = getBehavioralPerformanceData(SpikingDataDir, SpikeFileList)
    
    PFData      = repmat(struct('behavior_early_report',1, 'behavior_report', 1, ...
                                'task_stimulation', 1),length(SpikeFileList), 1);
        
    for nfile = 1:length(SpikeFileList)
        fname               = SpikeFileList(nfile).name;
        load([SpikingDataDir fname])
        PFData(nfile).behavior_early_report = behavior_early_report;
        PFData(nfile).task_stimulation      = task_stimulation;
        PFData(nfile).behavior_report       = behavior_report;
    end
end