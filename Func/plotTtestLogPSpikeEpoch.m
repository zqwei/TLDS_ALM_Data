%
% plotTtestLogPSpikeEpoch.m
% 
%
% Spiking dataset
%
% ----------------------------
% Output:
% 0: nonselective
% 1: homogenous
% 2: heterogenous
% 
% version 1.0
%
% -------------------------------------------------------------------------
% Ziqiang Wei
% weiz@janelia.hhmi.org
% 

function unitGroup = plotTtestLogPSpikeEpoch (logPValueEpoch)

    numUnit       = size(logPValueEpoch, 1);
    unitGroup     = nan(numUnit, 1);
    
    for nUnit     = 1:length(unitGroup)
        groupIndex = unique(logPValueEpoch(nUnit, :));
        groupIndex(groupIndex==0) = [];
        if isempty(groupIndex)
            unitGroup(nUnit) = 0;
        elseif length(groupIndex) == 1
            indexMat  = find(logPValueEpoch(nUnit, :) == groupIndex);
            if groupIndex == 1
                baseline  = 0;
            else
                baseline  = 7;
            end
            
            switch num2str(indexMat)
                case '1'
                    unitGroup(nUnit) = baseline + 1;
                case num2str([1 2])
                    unitGroup(nUnit) = baseline + 2;
                case num2str([1 3])
                    unitGroup(nUnit) = baseline + 3;
                case '2'
                    unitGroup(nUnit) = baseline + 4;
                case num2str([2 3])
                    unitGroup(nUnit) = baseline + 5;
                case '3'
                    unitGroup(nUnit) = baseline + 6;
                case num2str([1 2 3])
                    unitGroup(nUnit) = baseline + 7;
            end
            
        elseif length(groupIndex) == 2
            unitGroup(nUnit) = 15;
        end        
    end
    
end

