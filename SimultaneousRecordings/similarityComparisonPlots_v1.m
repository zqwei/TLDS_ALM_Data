addpath('../Func');
setDir;
load([TempDatDir 'SimilarityIndex.mat'])
Boxcar150MeanOld = Boxcar150Mean;
Boxcar150StdOld  = Boxcar150Std;
Boxcar250MeanOld = Boxcar250Mean;
Boxcar250StdOld  = Boxcar250Std;
GPFAMeanOld      = GPFAMean;
GPFAStdOld       = GPFAStd;
TLDSMeanOld      = TLDSMean;
TLDSStdOld       = TLDSStd;

load([TempDatDir 'SimilarityIndexHi.mat'])
Boxcar150Mean    = [Boxcar150MeanOld ;Boxcar150Mean ];
Boxcar150Std     = [Boxcar150StdOld  ;Boxcar150Std  ];
Boxcar250Mean    = [Boxcar250MeanOld ;Boxcar250Mean ];
Boxcar250Std     = [Boxcar250StdOld  ;Boxcar250Std  ];
GPFAMean         = [GPFAMeanOld      ;GPFAMean      ];
GPFAStd          = [GPFAStdOld       ;GPFAStd       ];
TLDSMean         = [TLDSMeanOld      ;TLDSMean      ];
TLDSStd          = [TLDSStdOld       ;TLDSStd       ];


matrix_table     = zeros(7*3, 3);
legendSet = {'Presample', 'Sample', 'Delay', 'Response', 'P-S', 'S-D', 'D-R'};
titleSet  = {'All', 'Contra', 'Ipsi'};
% 1st col: 150 box car



for nPlot = 1:length(titleSet)
    for nEpoch = 1:size(GPFAMean, 3)
    end
    
    [p, h] = ttest(GPFAs(:), TLDSs(:))
    
end





% 2nd col: 250 box car
% 3nd col: GPFA

