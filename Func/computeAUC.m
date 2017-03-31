function aocResult = computeAUC(scoreMatC, scoreMatE, nStep)
    minNum = min([scoreMatC; scoreMatE]);
    maxNum = max([scoreMatC; scoreMatE]);
    minNum = floor(minNum/nStep) * nStep - nStep;
    maxNum = ceil(maxNum/nStep) * nStep + nStep;
    [fic, ~] = histcounts(scoreMatC, minNum:nStep:maxNum);
    [fie, ~] = histcounts(scoreMatE, minNum:nStep:maxNum);
    aocResult = intXY([cumsum(fie)/sum(fie)], [cumsum(fic)/sum(fic)]);