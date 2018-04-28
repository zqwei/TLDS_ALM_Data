%
% [err, y_norm, y_est] = kfilter (y, Ph)
% 
% kalman filter of the neural traces
%
% Inputs:
% 
% y     -- observed data
% Ph    -- parameter set
% Ph.A  -- state transition matrix
% Ph.Q  -- state noise covarince
% Ph.x0 -- initial state mean
% Ph.Q0 -- initial state covariance
% Ph.C  -- observation matrix
% Ph.R  -- observation covariance
%
%
% Output:
% 
% err    -- sum squared estimation error
% y_norm -- sum norm of estimated data
% y_est  -- estimation of y
%
%
% Model:
%
%             y(t) = Ph.C * x(t) + Ph.D * y(s) + Ph.d + v(t)
%             x(t) = Ph.A * x(s) + Ph.bt(s) + w(s)
%             s      = t - 1
%        where
%             v ~ N(0,R)
%             w ~ N(0,Q)
%             x(k,1) ~ N(pi,Q0) (for any k)
%
% leave one neuron out is performed on:
%
%             z(t) = y(t) - D*y(s)
% where
%             z_est(t,i) = Ph.C_i * x_est(t) + Ph.d_i
%             x_est(t)   = E(x|Ph.C_-i, Ph.d_-i, A, bt, R_-i, Q, x0, Q0, z(t, -i))
%
% Ver: 1.0
%
% @ 2014 Ziqiang Wei
% weiz@janelia.hhmi.org
% 
% 

function [x_est, y_est] = kfilterForward (y, Ph, timePoint) % Leave one neuron out evaluation
    
    % y --- yDim x T x K

    [yDim, T, K] = size(y);
    
    if nargin == 2
        timePoint = [0, T];
    end

    x0           = Ph.x0;
    Q0           = Ph.Q0;
    A            = Ph.A;
    Q            = Ph.Q;
    C            = Ph.C;
    R            = Ph.R;
    d            = Ph.d;
    if size(d,1) ~= yDim
        d        = ones(yDim,1) * d;
    end
    
    if nargin == 2
        nt       = 1;
    else
        nt       = min(size(C,3), length(timePoint)-1);
    end
    
    xDim         = size(A,1);
        
    y_est        = nan(yDim, T, K);
    x_est        = nan(xDim, T, K);
    
    for nt_now   = 1:nt
        y(:,timePoint(nt_now)+1:timePoint(nt_now+1),:) = ...
            remove_mean(y(:,timePoint(nt_now)+1:timePoint(nt_now+1),:),d(:,nt_now));
    end
    
    
    Est = kalman_forward_w_n_lik(y, A, Q, C, R, x0, Q0, timePoint);
    x_est = Est.Xk_t;
            
    for nt_now  = 1:nt
        X_nt                = x_est(:,timePoint(nt_now)+1:timePoint(nt_now+1),:);
        X_nt                = reshape(X_nt, xDim, []);
        C_nt                = C(:,:,nt_now);
        Est_y_nt            = C_nt * X_nt;
        Est_y_n(:,timePoint(nt_now)+1:timePoint(nt_now+1),:) = reshape(Est_y_nt,yDim,[],K);
        y_est(:,timePoint(nt_now)+1:timePoint(nt_now+1),:) = ...
                Est_y_n(:,timePoint(nt_now)+1:timePoint(nt_now+1),:) + d(:,nt_now);
    end