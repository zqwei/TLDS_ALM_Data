addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Behavior_Simultaneous_Spikes.mat'])
oldBehavior  = nBehaviors;

load([TempDatDir 'Behavior_Simultaneous_HiSpikes.mat'])
oldBehavior  = [oldBehavior; nBehaviors];

load([TempDatDir 'Behavior_Simultaneous_HiSoundSpikes.mat'])
oldBehavior  = [oldBehavior; nBehaviors];
oldBehavior(52) = [];

nBehaviors = oldBehavior;

save([TempDatDir 'Combined_Simultaneous_Behaviors.mat'], 'nBehaviors')