% STATICTHRUST.m
%   Edgar Hernandez
%   06-12-25
% -----------------
% Purpose of this script is to calculate the maximum static thrust of a
% propellor using momentum theory. The results are first cut and are
% overestimations
% Equations from General Aviation Aircraft Design, Gudmendsson 2nd ed.
% -----------------
% Equation 1 (first cut)
%           Tmax = P^2/3 * (2*rho*Aprop)^1/3
% Equation 2 (refined analysis)
%           Tmax = kp*P^2/3 * (2*rho*Aprop)^1/3 * (1-Aspinner/Aprop)
% Units are standard SI, where Power is represented by Watts and outputs of
% equations are Newtons


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 6x4.5B Propellor %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This analysis uses the maximum rated power of the motor, 111W, to
% estimate the maximum power driving the propellor. Then static thrust is
% estimated using cruising conditions (El Paso Summer day. 

                        % Inputs and constants %
% Environmental
rho = 1.17; % kg/m^3
g = 9.81; % m/s^2 ... acceleration due to gravity
% Efficiencies
effProp = 0.95;
effMotor = 0.92;
effESC = 0.92;
kp = 0.3; % unitless, from Gudmendsson for RC planes approx... 0.2-0.45
% Prop Dimensions
Dprop_in = 6; % in
Dprop = Dprop_in/39.37; % m
Aprop = pi/4*Dprop^2; % m^2
Dspinner = Dprop*1/12; % m (NEEDS TO BE MEASURED)
Aspinner = pi/4*Dspinner^2; % m^2
% Conditions
Pmotor = 111; % W
% Motor properties
backEMF = 920; % kv = rpm/Vrms

                        % Prop Speed Calculations %
Vbatt = 4*3.8; % VDC
Vrms = Vbatt / sqrt(2); % Vrms
Nprop = Vrms*backEMF; % rev/min

                        % Refined Estimation %
Tmax = staticThrust(Aprop, Aspinner, Pprop, kp, rho); % N

                    % Thrust to Weight Estimations %
TW = Tmax / g / 0.42; % kg/kg for a 420g plane

                            % Outputs %
fprintf(" \n \n");

fprintf("Maximum static thrust and thrust to weight estimations " + ...
    "for %0.0f inch propeller spinning at %0.2f rpm. \nWith motor at %0.0f " + ...
    "W of power. \n", Dprop_in, Nprop, Pmotor);
fprintf(" \nRefined estimation w/ kp = %0.2f : \n%0.2f N of thrust \n%0.2f T/W \n", kp, Tmax, TW);

fprintf(" \n \n");

