function airfoilPlotter_NACA(m, p, tc, c, n, te_option)
% AIRFOILPLOTTER_NACA.m
% Author: Edgar Hernandez
% Date: June 19, 2025
% -------
% The purpose of this function is to plot the airfoil specified by the
% inputs.
% NACA "m p t/c"
% Inputs:
%   m --> max camber, %
%   p --> mac camber position from LE, %
%   tc -> thickness to chord ratio, % 
%   c --> chord length, m
%   te_option --> 0 = open TE       1 = closed TE
%   n --> number of points to plot, linearly spaced
% 
% EDGAR: limits to inputs aren't set so be careful

% Symmetric airfoil constants
a0 = 0.2969;
a1 = -0.126;
a2 = -0.3516;
a3 = 0.2843;
switch te_option
    case 0
        a4 = -0.1015;
    case 1
        a4 = -0.1036;
end

% Evaluate the points for the chord of the airfoil
x = linspace(0,1,n/2)
c = x * c;

% Evaluate the points of the symmetric airfoil
yt = ones(1, n/2);
% for i = 0:length(yt)
%     yt(i) = 5*tc*(a0*sqrt(i) - a1*i - a2*i^2 + a3*i^3 - a4*i^4);
% end

yt = 5*tc.*(a0.*sqrt(x) - a1.*x - a2.*x.^2 + a3.*x.^3 - a4.*x.^4);
yl = -yt;


airfoilPlot = figure();
% Plot the symmetric airfoil
plot(c, yt, c, yl)


if m == 0 && p == 0
    type = "symmetric airfoil";
else
    type = "nonsymettric airfoil";
end


end