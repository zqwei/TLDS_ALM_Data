% col #1: sample-sample
% col #2: delay-delay
% col #3: response-response
% col #4: sample-delay
% col #5: delay-response

% row #1: all
% row #2: contra
% row #3: ipsi

function [similarityMean, simlarityStd] = computeSimilarityEpochTrialType(scoreMat, scoreMatRef, timePoints, totTargets)
    similarityMean = zeros(3, 5);
    simlarityStd   = zeros(3, 5);
    
    similarityIndex = computeSimilarityEpoch(scoreMat, scoreMatRef, timePoints);
    similarityMean(1, :) = similarityIndex(1, :);
    simlarityStd(1, :)   = similarityIndex(2, :);
    
    
    similarityIndex = computeSimilarityEpoch(scoreMat(totTargets, :), scoreMatRef(totTargets, :), timePoints);
    similarityMean(2, :) = similarityIndex(1, :);
    simlarityStd(2, :)   = similarityIndex(2, :);
    
    similarityIndex = computeSimilarityEpoch(scoreMat(~totTargets, :), scoreMatRef(~totTargets, :), timePoints);
    similarityMean(3, :) = similarityIndex(1, :);
    simlarityStd(3, :)   = similarityIndex(2, :);    