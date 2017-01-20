% col #1: presample - presample
% col #2: sample-sample
% col #3: delay-delay
% col #4: response-response

% col #5: presample - sample
% col #6: sample-delay
% col #7: delay-response


function similarityIndex = computeSimilarityEpochwithPreSample(scoreMat, scoreMatRef, timePoints)

    similarityIndex = nan(2, 7);
    
    similarMat = corr(scoreMat, 'type', 'Spearman') - corr(scoreMatRef, 'type', 'Spearman');
    similarMat(isnan(similarMat)) = 0;
    similarMat(similarMat<0) = 0;
    
    for nTime  = 1:length(timePoints)-1
        similarMatSlice = similarMat(timePoints(nTime)+1:timePoints(nTime+1), timePoints(nTime)+1:timePoints(nTime+1));
        similarMatSlice(eye(size(similarMatSlice))==1) = nan;
        similarityIndex(1, nTime) = nanmean(similarMatSlice(:));
        similarityIndex(2, nTime) = nanstd(similarMatSlice(:))/sqrt(sum(~isnan(similarMatSlice(:))));
    end
    
    numIndex = length(timePoints)-1;
    
    for nTime  = 1:length(timePoints)-2
        similarMatSlice = similarMat(timePoints(nTime)+1:timePoints(nTime+1), timePoints(nTime+1)+1:timePoints(nTime+2));
        similarityIndex(1, numIndex+nTime) = nanmean(similarMatSlice(:));
        similarityIndex(2, numIndex+nTime) = nanstd(similarMatSlice(:))/sqrt(sum(~isnan(similarMatSlice(:))));
    end