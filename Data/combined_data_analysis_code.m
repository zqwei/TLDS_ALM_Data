load('Combined_Simultaneous_Spikes.mat')

% EV computed for each session using lono
explainedCRR = [0.094;0.216;0.128;0.198;0.357;0.084;0.107;0.558;0.127;0.145;0.416;0.183;0.290;0.360;0.466;0.411;0.366;0.438;0.364;0.395;0.406;0.389;0.528;0.583;0.231;NaN]; % from EV_correct_error.m
numUnits     = [6;7;8;7;11;6;7;6;7;8;15;10;12;17;18;10;12;14;18;18;11;12;22;15;16;10];

sessionIndex = [11;15;18;21;23;24]; % I picked ones with high EVs

for nSession = 1:length(nDataSet)-1
    % psth
    aveDataSet(nSession).unit_yes_trial = squeeze(mean(nDataSet(nSession).unit_yes_trial, 1));
    aveDataSet(nSession).unit_no_trial  = squeeze(mean(nDataSet(nSession).unit_no_trial, 1));
    
    % x fit
    aveDataSet(nSession).x_yes_fit      = squeeze(mean(nDataSet(nSession).x_yes_fit, 1));
    aveDataSet(nSession).x_no_fit       = squeeze(mean(nDataSet(nSession).x_no_fit, 1));
    
    % y fit
    aveDataSet(nSession).unit_yes_fit   = squeeze(mean(nDataSet(nSession).unit_yes_fit, 1));
    aveDataSet(nSession).unit_no_fit    = squeeze(mean(nDataSet(nSession).unit_no_fit, 1));
end


aveDataSet = aveDataSet(sessionIndex);

save('Combined_Ave_Spikes', 'aveDataSet', 'params');