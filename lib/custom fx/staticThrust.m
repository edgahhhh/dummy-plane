function [Tstatic] = staticThrust(Aprop, Aspinner, Pprop, kp, rho)
% STATICTHRUST.m
% Author: Edgar Hernandez
% Date: June 13, 2025
% ----------------------
% Purpose:
%   To simplify evaluations of static thrust for different size propellors 
%   at different driving powers
% Description:
%   This function utilzes actuating disk theory for propellors, where
%   estimations of performance are done using the oversestimation of the
%   theory, while correcting it using an empirical function.
%   The functions are based off Gudemndssons, General Aviation Aircraft
%   Design 2nd ed.
%       Equation: Tmax = kp*P^2/3 * (2*rho*Aprop)^1/3 * (1-Aspinner/Aprop)
%   If inputs for kp and rho aren't given, they are assumed as 1 and 1.225
%   kg/m^3, respectively.
% ---------------------
% Inputs: 
%   Aprop ------> Propellor disk area [m^2]
%   Aspinner ---> Hub area [m^2]
%   Pprop ------> Propellor driving power [W]
%   kp ---------> Correction factor [empirical]
%   rho --------> Air density [kg/m^3]
% Outputs:
%   Tstatic ----> Static thrust [N]

% Inputs evaluation
Ap = Aprop;
Asp = Aspinner;
P = Pprop;
if nargin < 4
    k = 1;
    r = 1.225;
elseif nargin < 5
    k = kp;
    r = 1.225;
else
    k = kp;
    r = rho;
end

% Evaluating static thrust
Fn = k * P^(2/3) * (2*r*Ap)^(1/3) * (1-Asp/Ap);

% Output evalutation
Tstatic = Fn;

end