function currTime = getThresTime(y, thresValue, minCurrTime, maxCurrTime)
    
    currTimeSet   = find(y > thresValue);
    if ~isempty(currTimeSet)
        currTime  = min(currTimeSet(currTimeSet>minCurrTime));
    else
        currTime  = maxCurrTime;
    end