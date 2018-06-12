function x = computeMeanWithoutDiag(A)
    A                  = squeeze(A);
    
    if ~ismatrix(A) || size(A,1)~=size(A,2)
        error('wrong matrix')
    end
    
    A(eye(size(A))==1) = nan;
    x                  = nanmean(A(:));

end