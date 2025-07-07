% SIZING_V2.m
% Author: Edgar Hernandez
% Date: July 6, 2025
% ----------------------
% The purpose of this script is to document the current sizing iteration of
% the aircraft. The script shall write the sizing results as a .mat file in
% \results
% ----------------------

setup

% -- Inputs --
conditions.mtow = 0.42; 
conditions.g = 9.81;
conditions.rho_static = 1.17;
conditions.V_stall = 8;
conditions.cl_max = 1.2;

% -- Wing Design --
% Calling function to size wing based off conditions
wing = wing_sizing_for_stall(conditions, 0, 0);
wing.b = 0.762; % wingspan [m], ~ 2.5 ft
wing.c = wing.S / wing.b; % chord length [m]

% Saving wing design as .mat in /results
savetoresults(wing)


function savetoresults(wing)
trunkPath = pwd;
cd results
save('sizingv2results', 'wing')
cd(trunkPath)
end