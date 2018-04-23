% col #1: presample - presample
% col #2: sample-sample
% col #3: delay-delay
% col #4: response-response

% col #5: presample - sample
% col #6: sample-delay
% col #7: delay-response

% row #1: all
% row #2: contra
% row #3: ipsi

function [similarityMean, simlarityStd] = computeSimilarityEpochTrialType(scoreMat, scoreMatRef, timePoints, totTargets)
    similarityMean = zeros(3, 7);
    simlarityStd   = zeros(3, 7);
    
    similarityIndex = computeSimilarityEpochwithPreSample(scoreMat, scoreMatRef, timePoints); %computeSimilarityEpoch(scoreMat, scoreMatRef, timePoints);
    similarityMean(1, :) = similarityIndex(1, :);
    simlarityStd(1, :)   = similarityIndex(2, :);
    
    
    similarityIndex = computeSimilarityEpochwithPreSample(scoreMat(totTargets, :), scoreMatRef(totTargets, :), timePoints); %computeSimilarityEpoch(scoreMat(totTargets, :), scoreMatRef(totTargets, :), timePoints);
    similarityMean(2, :) = similarityIndex(1, :);
    simlarityStd(2, :)   = similarityIndex(2, :);
    
    similarityIndex = computeSimilarityEpochwithPreSample(scoreMat(~totTargets, :), scoreMatRef(~totTargets, :), timePoints); %computeSimilarityEpoch(scoreMat(~totTargets, :), scoreMatRef(~totTargets, :), timePoints);
    similarityMean(3, :) = similarityIndex(1, :);
    simlarityStd(3, :)   = similarityIndex(2, :);