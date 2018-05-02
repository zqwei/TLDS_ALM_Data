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
Boxcar150MeanOLd    = [Boxcar150MeanOld ;Boxcar150Mean ];
Boxcar150StdOld     = [Boxcar150StdOld  ;Boxcar150Std  ];
Boxcar250MeanOld    = [Boxcar250MeanOld ;Boxcar250Mean ];
Boxcar250StdOld     = [Boxcar250StdOld  ;Boxcar250Std  ];
GPFAMeanOld         = [GPFAMeanOld      ;GPFAMean      ];
GPFAStdOld          = [GPFAStdOld       ;GPFAStd       ];
TLDSMeanOld         = [TLDSMeanOld      ;TLDSMean      ];
TLDSStdOld          = [TLDSStdOld       ;TLDSStd       ];

load([TempDatDir 'SimilarityHiSoundIndex.mat'])
Boxcar150Mean    = [Boxcar150MeanOld ;Boxcar150Mean ];
Boxcar150Std     = [Boxcar150StdOld  ;Boxcar150Std  ];
Boxcar250Mean    = [Boxcar250MeanOld ;Boxcar250Mean ];
Boxcar250Std     = [Boxcar250StdOld  ;Boxcar250Std  ];
GPFAMean         = [GPFAMeanOld      ;GPFAMean      ];
GPFAStd          = [GPFAStdOld       ;GPFAStd       ];
TLDSMean         = [TLDSMeanOld      ;TLDSMean      ];
TLDSStd          = [TLDSStdOld       ;TLDSStd       ];


legendSet = {'Presample', 'Sample', 'Delay', 'Response', 'P-S', 'S-D', 'D-R'};
titleSet  = {'All', 'Contra', 'Ipsi'};
% colorSet  = {'k', 'b', 'r', 'g', 'c', 'y', 'm'};

figure;
for nPlot = 1:length(titleSet)
    subplot(1, 3, nPlot)
    hold on
    for nEpoch = 5:size(GPFAMean, 3)
%         errorbarxy(squeeze(GPFAMean(:, nPlot, nEpoch)), squeeze(TLDSMean(:, nPlot, nEpoch)), ...
%             squeeze(GPFAStd(:, nPlot, nEpoch)), squeeze(TLDSStd(:, nPlot, nEpoch)),...
%             {[colorSet{nEpoch} 'o'], colorSet{nEpoch}, colorSet{nEpoch}})
        plot(squeeze(GPFAMean(:, nPlot, nEpoch)), squeeze(TLDSMean(:, nPlot, nEpoch)), 'o')
    end
    plot([0 1], [0 1], '--k')
    box off
    xlim([0 0.6])
    ylim([0 0.6])
    xlabel('GPFA similarity index')
    ylabel('TLDS similarity index')
    title(titleSet{nPlot})
    set(gca, 'TickDir', 'out')
    
    GPFAs = squeeze(GPFAMean(:, nPlot, 5:end));
    TLDSs = squeeze(TLDSMean(:, nPlot, 5:end));
    
    [p, h] = signrank(GPFAs(:), TLDSs(:))
    
end

setPrint(8*3, 6, 'Plots/SimilarityIndex_GPFA_TLDS')


% % % figure;
% % % for nPlot = 1:length(titleSet)
% % %     for nEpoch = 5:size(GPFAMean, 3)
% % %         subplot(3, 3, (nEpoch-5)*3+nPlot)
% % %         hold on
% % %         errorbarxy(squeeze(GPFAMean(:, nPlot, nEpoch)), squeeze(TLDSMean(:, nPlot, nEpoch)), ...
% % %             squeeze(GPFAStd(:, nPlot, nEpoch)), squeeze(TLDSStd(:, nPlot, nEpoch)), {'ko', 'k', 'k'})
% % %         plot([0 1], [0 1], '--k')
% % %         box off
% % %         xlim([0 0.6])
% % %         ylim([0 0.6])
% % %         xlabel('GPFA similarity index')
% % %         ylabel('TLDS similarity index')
% % %         title(titleSet{nPlot})
% % %         set(gca, 'TickDir', 'out')    
% % %         GPFAs = squeeze(GPFAMean(:, nPlot, nEpoch));
% % %         TLDSs = squeeze(TLDSMean(:, nPlot, nEpoch));
% % %         [p, h] = ttest(GPFAs(:), TLDSs(:), 'tail', 'right')
% % %     end
% % %     
% % % end
% % % 
% % % setPrint(8*3, 6*3, 'Plots/SimilarityIndex_GPFA_TLDS')
% % % 
% % % % 
% % % % 
% % % % figure;
% % % % for nPlot = 1:length(titleSet)
% % % %     subplot(1, 3, nPlot)
% % % %     hold on
% % % %     for nEpoch = 1:size(GPFAMean, 3)
% % % %         errorbarxy(squeeze(Boxcar150Mean(:, nPlot, nEpoch)), squeeze(Boxcar250Mean(:, nPlot, nEpoch)), ...
% % % %             squeeze(Boxcar150Std(:, nPlot, nEpoch)), squeeze(Boxcar250Std(:, nPlot, nEpoch)),...
% % % %             {[colorSet{nEpoch} 'o'], colorSet{nEpoch}, colorSet{nEpoch}})
% % % %     end
% % % %     plot([0 1], [0 1], '--k')
% % % %     box off
% % % %     legend(legendSet)
% % % %     legend('location', 'southeast')
% % % %     legend('boxoff')
% % % %     xlim([0 1])
% % % %     ylim([0 1])
% % % %     xlabel('Boxcar 150ms similarity index')
% % % %     ylabel('Boxcar 250ms similarity index')
% % % %     title(titleSet{nPlot})
% % % % end
% % % % 
% % % % setPrint(8*3, 6, 'Plots/SimilarityIndex_BoxCar')
% % % 
% % % 
% % % figure;
% % % for nPlot = 1:length(titleSet)
% % %     subplot(1, 3, nPlot)
% % %     hold on
% % %     for nEpoch = 5:size(GPFAMean, 3)
% % %         errorbarxy(squeeze(Boxcar250Mean(:, nPlot, nEpoch)), squeeze(TLDSMean(:, nPlot, nEpoch)), ...
% % %             squeeze(Boxcar250Std(:, nPlot, nEpoch)), squeeze(TLDSStd(:, nPlot, nEpoch)),...
% % %             {[colorSet{nEpoch} 'o'], colorSet{nEpoch}, colorSet{nEpoch}})
% % %     end
% % %     plot([0 1], [0 1], '--k')
% % %     box off
% % % %     legend(legendSet)
% % % %     legend('location', 'southeast')
% % % %     legend('boxoff')
% % %     xlim([0 0.6])
% % %     ylim([0 0.6])
% % %     xlabel('Boxcar 250ms similarity index')
% % %     ylabel('TLDS similarity index')
% % %     title(titleSet{nPlot})
% % %     set(gca, 'TickDir', 'out')
% % %     
% % %     GPFAs = squeeze(Boxcar250Mean(:, nPlot, 5:end));
% % %     TLDSs = squeeze(TLDSMean(:, nPlot, 5:end));
% % %     
% % %     [p, h] = ttest(GPFAs(:), TLDSs(:))
% % %     
% % % end
% % % 
% % % setPrint(8*3, 6, 'Plots/SimilarityIndex_BoxCar_TLDS')
% % % 
% % % 
% % % figure;
% % % hold on
% % % for nEpoch = 5:size(GPFAMean, 3)
% % %     errorbarxy(squeeze(TLDSMean(:, 3, nEpoch)), squeeze(TLDSMean(:, 2, nEpoch)), ...
% % %         squeeze(TLDSStd(:, 3, nEpoch)), squeeze(TLDSStd(:, 2, nEpoch)),...
% % %         {[colorSet{nEpoch} 'o'], colorSet{nEpoch}, colorSet{nEpoch}})
% % % end
% % % 
% % % GPFAs = squeeze(TLDSMean(:, 3, :));
% % % TLDSs = squeeze(TLDSMean(:, 2, :));
% % % [p, h] = ttest(GPFAs(:), TLDSs(:))
% % % 
% % % plot([0 1], [0 1], '--k')
% % % box off
% % % % legend(legendSet)
% % % % legend('location', 'southeast')
% % % % legend('boxoff')
% % % xlim([0 0.6])
% % % ylim([0 0.6])
% % % xlabel('Contra similarity index')
% % % ylabel('Ipsi similarity index')
% % % % title(titleSet{nPlot})
% % % set(gca, 'TickDir', 'out')
% % % 
% % % setPrint(8, 6, 'Plots/SimilarityIndex_TLDS_ContraIpsi')
% % % 
% % % close all