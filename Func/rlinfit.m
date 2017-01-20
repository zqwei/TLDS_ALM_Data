function [slope,intercept] = rlinfit(x,y,p)

%RLINFIT   Robust linear regression
%   [slope,intercept] = RLINFIT(x,y) returns the coefficient estimates
%   (slope and intercept) for a robust linear regression of the responses
%   in y on the predictors in x.
%
%   RLINFIT uses the Theil-Sen method where the slope is given by the
%   median of the slopes (yj-yi)/(xj-xi) determined by all pairs of
%   sample points.
%
%   Since RLINFIT uses all pairs of sample points, this technique can be
%   slow with large samples:
%   [...] = RLINFIT(x,y,P) uses only P percent of the total number of
%   points to determine the coefficients. The points are selected randomly.
%   P must be in ]0;100].
%
%   Example:
%   -------
%   x = linspace(0,1,100);
%   y = 100*x+100 + randn(1,100)*10;
%   I = randperm(50);
%   y(I(1:15)) = 200+rand(1,15)*100;
%   [a,b] = rlinfit(x,y);
%   plot(x,y,'.')
%   p = polyfit(x,y,1);
%   xi = [0 1];
%   plot(x,y,'.',xi,[100 200],'k:',xi,a*xi+b,'r',xi,p(1)*xi+p(2),'g')
%   legend({'data','actual line','rlinfit','polyfit'})
%
%   See also polyfit, regress, robustls, robustfit
%
%   -- Damien Garcia -- 2011/12, revised 2012/05
%   website: <a
%   href="matlab:web('http://www.biomecardio.com')">www.BiomeCardio.com</a>

error(nargchk(2,3,nargin));
if nargin==2, p = 100; end
assert(p>0 & p<=100,'P must be >0 and <=100')

assert(numel(y)==numel(x),'x and y must have same number of elements.')

I = isfinite(x) & isfinite(y);
x = x(I);
y = y(I);

N = numel(x);
I = randperm(N);
n = round(N*p/100);
I = I(1:n);
x = x(I);
y = y(I);

C = combnk(1:n,2);
slope = median((y(C(:,2))-y(C(:,1)))./(x(C(:,2))-x(C(:,1))));
if nargout>1
    intercept = median(y-slope*x);
end
