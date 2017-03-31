rng('Shuffle');

totStage   = 4; 
Arot       = 0.1;
Aspec      = 0.99;
Arand      = 0.03;
Q0max      = 0.3;
Rmin       = 0.1;
Rmax       = 10.1;

xDim       = 2;
yDim       = 100;
T          = 60;
nTrial     = 10;
timePoints = [20 40];
LDS.A      = zeros(xDim, xDim, totStage);
LDS.Q      = zeros(xDim, xDim, totStage);
LDS.V0     = 0.001*eye(xDim);
LDS.x0     = randn(xDim,1)/3;
LDS.C      = zeros(yDim, xDim, totStage);
LDS.R      = zeros(yDim, yDim, totStage);

for nStage            = 1:totStage
    A                 = eye(xDim)+Arand*randn(xDim);
    A                 = A./max(abs(eig(A)))*Aspec;
    MAS               = randn(xDim); 
    MAS               = (MAS-MAS')/2;
    LDS.A(:,:,nStage) = expm(Arot.*(MAS))*A;
    LDS.Q(:,:,nStage) = eye(xDim)*0.00001;
    LDS.C(:,:,nStage) = randn(yDim,xDim)./sqrt(3*xDim);
    LDS.R(:,:,nStage) = diag(rand(yDim,1)*Rmax+Rmin);
end

% load('LDS.mat', 'LDS')

LDS.V0     = 0.01*eye(xDim);

for nStage            = 1:totStage
    LDS.Q(:,:,nStage) = eye(xDim)*0.00001;
end

% generate outputs of LDS
[X,~]  = SimulateLDS_MultiStage(LDS, T, nTrial, timePoints);

figure;
hold on
for nTrial = 1:4
    XTrial = squeeze(X(:, :, nTrial));
    plot(XTrial(1,:), XTrial(2,:))
    plot(XTrial(1,1), XTrial(2,1),'ok')
    plot(XTrial(1,timePoints(1)), XTrial(2,timePoints(1)),'ob')
    plot(XTrial(1,timePoints(2)), XTrial(2,timePoints(2)),'or')
end

% for nStage            = 1:totStage
%     LDS.Q(:,:,nStage) = eye(xDim)*0.0003;
% end

for nStage            = 1:totStage
    LDS.Q(1,2,nStage) = 0.00003;
    LDS.Q(2,1,nStage) = 0.00000;
end

% generate outputs of LDS
[X,~]  = SimulateLDS_MultiStage(LDS, T, nTrial, timePoints);

figure;
hold on
for nTrial = 1:4
    XTrial = squeeze(X(:, :, nTrial));
    plot(XTrial(1,:), XTrial(2,:))
    plot(XTrial(1,1), XTrial(2,1),'ok')
    plot(XTrial(1,timePoints(1)), XTrial(2,timePoints(1)),'ob')
    plot(XTrial(1,timePoints(2)), XTrial(2,timePoints(2)),'or')
end
