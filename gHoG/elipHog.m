function [h2] = elipHog(p2, sigma_x, sigma_y, theta)

% returns a rotational
%   Determinant of Hessian of Gaussian filter of size HSIZE with standard deviation
%   SIGMA (positive). HSIZE can be a vector specifying the number of rows
%   and columns in H or a scalar, in which case H is a square matrix.
%   The default HSIZE is [5 5], the default SIGMA is 0.5.

% p2=[15 15];
% sigma_x = 4;
% sigma_y = 4;
%theta = 
% Determinant of Hessian of Gaussian
% first calculate Gaussian
siz   = (p2-1)/2;

a = cos(theta)^2/2/sigma_x^2 + sin(theta)^2/2/sigma_y^2;
b = -sin(2*theta)/4/sigma_x^2 + sin(2*theta)/4/sigma_y^2 ;
c = sin(theta)^2/2/sigma_x^2 + cos(theta)^2/2/sigma_y^2;

[x,y] = meshgrid(-siz(2):1:siz(2),-siz(1):1:siz(1));
arg = ( - (a*(x).^2 + 2*b*(x).*(y) + c*(y).^2)) ;

%      [x,y] = meshgrid(-siz(2):siz(2),-siz(1):siz(1));
%      arg   = -(x.*x + y.*y)/(2*std2);

h = exp(arg);
h(h<eps*max(h(:))) = 0;

sumh = sum(h(:));
if sumh ~= 0,
    h  = h/sumh;
end;
% now calculate determinant of hessian
Lxx = ((2*a*x+2*b*y).^2-2*a);
Lyy = ((2*c*y+2*b*x).^2-2*c);
Lxy = (2*a*x+2*b*y)*(2*b*x + 2*c*y) - 2*b;
Lyx = -2*b + (2*b*x+2*c*y)*(2*a*x + 2*b*y);


hess = Lxx*Lyy - Lxy*Lxy;

%%
h1 = h.*hess;

%h2 = h1;
h2 = h1 - sum(h1(:))/numel(h1);

%hess = ((2*a*x+2*b*y).^2-2*a).*((2*c*y+2*b*x).^2-2*c) - ((2*a*x+2*b*y).*(2*b*x+2*c*y)-2*b).^2;
%h1 = h.*h.*hess;
%h2 = h1 - sum(h1(:))/prod(p2); % make the filter sum to zero