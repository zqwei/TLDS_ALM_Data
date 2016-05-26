%
% coeffLDA.m
%
%
% ----------------------------
% Output:
%
% version 2.0
%
% based on paper:
%
% Guo et al., Biostatistics, 2007
% 
% no cross validation
%
% -------------------------------------------------------------------------
% Ziqiang Wei
% weiz@janelia.hhmi.org
% 

function coeffMat            = coeffTrialLDA(nSessionData, totTargets)
    
    T                        = size(nSessionData, 3);
    
    nSessionData             = permute(nSessionData, [2 1 3]);
    totTargets               = totTargets(:,ones(1, T));
    
    nSessionData             = reshape(nSessionData, size(nSessionData, 1), []);
    totTargets               = totTargets(:);
    
    coeffMat                 = coeffClassify(nSessionData', totTargets);
end


function coeffMat            = coeffClassify(nSessionData, totTargets)
    
    
    % choice of parameters follows 'min-min' rul in Guo's paper
    % Here we only consider to use a Gamma which is close enough to zero
    
    zeroVarUnits           = var(nSessionData, 1) < 1e-5;
    coeffLength            = size(nSessionData, 2);
    nSessionData           = nSessionData(:, ~zeroVarUnits);
           
    obj                    = fitcdiscr(nSessionData, totTargets, ...
                                    'DiscrimType', 'pseudoLinear');
   
    coeff                  = obj.Coeffs(1,2).Linear;
    if norm(coeff)         > 0
        coeff              = coeff./norm(coeff);
    end
    
    if sum(zeroVarUnits)   > 0
        coeffOld           = coeff;
        coeff              = zeros(coeffLength, 1);
        coeff(~zeroVarUnits) = coeffOld;
    end
    
    coeffMat               = coeff;
        
end