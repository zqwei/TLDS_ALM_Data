% statistics for depth min, max and number of pyramidal cells

statsFile = fopen('stats_file.csv', 'a');

addpath('../Func');
setDir;

load([TempDatDir 'Shuffle_Spikes.mat']);
spkDataSet = nDataSet;

load([TempDatDir 'Simultaneous_Spikes.mat']);


for nSession = 1:length(nDataSet)
    
    depth = nan(length(nDataSet(nSession).nUnit), 1);
    pyr   = nan(length(nDataSet(nSession).nUnit), 1);
    
    sessionIndex = nDataSet(nSession).sessionIndex;
    
    for nUnit = 1:length(nDataSet(nSession).nUnit)
        unitIndex = nDataSet(nSession).nUnit(nUnit);
        cellIndex = [spkDataSet.sessionIndex] == sessionIndex & [spkDataSet.nUnit] == unitIndex;
        depth(nUnit) = spkDataSet(cellIndex).depth_in_um;
        pyr(nUnit) = spkDataSet(cellIndex).cell_type;
    end
    
    fprintf(statsFile, '%f, %f, %d\n', [min(depth), max(depth), sum(pyr)]);
    
end

load([TempDatDir 'Shuffle_HiSpikes.mat']);
spkDataSet = nDataSet;

load([TempDatDir 'Simultaneous_HiSpikes.mat']);


for nSession = 1:length(nDataSet)
    
    depth = nan(length(nDataSet(nSession).nUnit), 1);
    pyr   = nan(length(nDataSet(nSession).nUnit), 1);
    
    sessionIndex = nDataSet(nSession).sessionIndex;
    
    for nUnit = 1:length(nDataSet(nSession).nUnit)
        unitIndex = nDataSet(nSession).nUnit(nUnit);
        cellIndex = [spkDataSet.sessionIndex] == sessionIndex & [spkDataSet.nUnit] == unitIndex;
        depth(nUnit) = spkDataSet(cellIndex).depth_in_um;
        pyr(nUnit) = spkDataSet(cellIndex).cell_type;
    end
    
    fprintf(statsFile, '%f, %f, %d\n', [min(depth), max(depth), sum(pyr)]);
    
end