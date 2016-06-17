% col #1: sample-sample
% col #2: delay-delay
% col #3: response-response
% col #4: sample-delay
% col #5: delay-response


function similarityIndex = computeSimilarityEpoch(scoreMat, scoreMatRef, timePoints)
    
    similarMat = corr(scoreMat, 'type', 'Spearman') - corr(scoreMatRef, 'type', 'Spearman');
    similarMat(isnan(similarMat)) = 0;
    similarMat(similarMat<0) = 0;
    
    for nTime  = 2:length(timePoints)-1
        similarMatSlice = similarMat(timePoints(nTime)+1:timePoints(nTime+1), timePoints(nTime)+1:timePoints(nTime+1));
        similarMatSlice(eye(size(similarMatSlice))==1) = nan;
        similarityIndex(1, nTime-1) = nanmean(similarMatSlice(:));
        similarityIndex(2, nTime-1) = nanstd(similarMatSlice(:))/sqrt(sum(~isnan(similarMatSlice(:))));
    end
    
    numIndex = length(timePoints)-3;
    
    for nTime  = 2:length(timePoints)-2
        similarMatSlice = similarMat(timePoints(nTime)+1:timePoints(nTime+1), timePoints(nTime+1)+1:timePoints(nTime+2));
        similarityIndex(1, numIndex+nTime) = nanmean(similarMatSlice(:));
        similarityIndex(2, numIndex+nTime) = nanstd(similarMatSlice(:))/sqrt(sum(~isnan(similarMatSlice(:))));
    end