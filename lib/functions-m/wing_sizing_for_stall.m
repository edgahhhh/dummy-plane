function outStruct = wing_sizing_for_stall(conditions, cL_option, AR_option)
% WING_SIZING_FOR_STALL.m
%   Estimates wing sizing based off a stall constraint
% ---------------------------------------------------------------
% Author: Edgar Hernandez
% Date: July 6, 2025
% ---------------------------------------------------------------
% INPUTS:
%   conditions - struct with fields:
%       .mtow       | Max takeoff weight            | [kg]
%       .g          | Gravitational acceleration    | [m/s^2]
%       .rho_static | Air density at stall          | [kg/m^3]
%       .V_stall    | Stall speed                   | [m/s]
%       .cl_max     | Max cl or cL (based on cL_option) | [–]
%       .AR         | Aspect ratio (if AR_option = 1)   | [–]
%
%   cL_option - If 0, cL = 0.9 * cl_max; if 1, cL = cl_max directly
%   AR_option - If 1, calculates span (b) and chord (c); requires .AR
%
% OUTPUT:
%   outStruct - struct with fields:
%       .qbar   | Dynamic pressure at stall            | [Pa]
%       .cL_max | Maximum lift coefficient             | [–]
%       .S      | Wing area                            | [m^2]
%       .b      | Wingspan (only if AR_option = 1)     | [m]
%       .c      | Chord length (only if AR_option = 1) | [m]
% ---------------------------------------------------------------
% PHILOSOPHY:
%   The method is based on the lift coefficient equation:
%
%       cL = L / (qbar * S)
%
%   For steady flight at the stall condition, lift (L) equals the 
%   aircraft's weight (MTOW * g). The function assumes a maximum 
%   lift coefficient (cl_max), either given directly as cL or 
%   estimated using the relation cL ≈ 0.9 * cl.
%
%   If aspect ratio information is provided, the function can also 
%   estimate the wingspan and chord length.
% 
%   Note that any ground effects are currently neglected in this function.

   %% --- Input validation ---
    requiredFields = {'mtow', 'g', 'rho_static', 'V_stall', 'cl_max'};
    if AR_option == 1
        requiredFields{end+1} = 'AR';
    end

    requireFields(conditions, requiredFields, 'conditions');

    %% --- Extract variables ---
    mtow = conditions.mtow;
    g    = conditions.g;
    rho  = conditions.rho_static;
    V    = conditions.V_stall;
    cl   = conditions.cl_max;

    if AR_option == 1
        AR = conditions.AR;
    end

    %% --- Compute cL based on option ---
    switch cL_option
        case 0
            cL = 0.9 * cl;
        case 1
            cL = cl;
        otherwise
            error('Invalid value for cL_option. Must be 0 or 1.');
    end

    %% --- Compute dynamic pressure ---
    qbar = 0.5 * rho * V^2;

    %% --- Compute wing area ---
    % Lift = Weight at stall = mtow * g
    S = (mtow * g) / (qbar * cL);

    %% --- Optional: Compute wingspan and chord ---
    if AR_option == 1
        b = sqrt(AR * S);  % Wingspan
        c = S / b;         % Chord length
    else
        b = NaN;
        c = NaN;
    end

    %% --- Output struct ---
    outStruct = struct( ...
        'qbar',   qbar, ...
        'cL_max', cL, ...
        'S',      S, ...
        'b',      b, ...
        'c',      c ...
    );
end