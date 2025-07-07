function [x, V, M, I_required_bending, t_wall_required] = calculateWingInertia(weight, flightConditions, loadFactor, safetyFactor, geometry, liftDistribution)
    % calculateWingInertia
    % Calculates shear force, bending moment, and required structural properties
    % along the semi-span of a wing under given loading conditions.
    %
    % Inputs:
    %   weight           - Total aircraft weight [kg]
    %   flightConditions - Struct containing flight parameters (currently unused)
    %                      e.g., .airspeed, .altitude, etc.
    %   loadFactor       - Load factor (n), dimensionless (e.g., 3.8 for normal category aircraft)
    %   safetyFactor     - Safety factor (s), dimensionless (e.g., 1.5)
    %   geometry         - Struct with wing geometry:
    %                      .span       - Total wingspan [m]
    %                      .chordRoot  - Root chord length [m]
    %                      .chordTip   - Tip chord length [m] (currently unused)
    %                      .rootSize   - Width of center body section [m]
    %   liftDistribution - String defining lift distribution type (only 'rectangular' supported)
    %
    % Outputs:
    %   x                - Spanwise positions along the semi-wing [m]
    %   V                - Shear force distribution at each span location [N]
    %   M                - Bending moment distribution at each span location [N·m]
    %   I_required_bending - Required moment of inertia to resist bending stress [m^4]
    %   t_wall_required  - Required wall thickness to resist shear (monokote wrap) [m]

    % Constants
    g = 9.81;  % gravity

    % Material properties (balsa + monokote skin)
    rho_balsa = 150;          % kg/m³
    sigma_allow = 1.6e5 * rho_balsa;  % Pa (tensile strength)
    tau_allow = 1e5;          % Pa (assumed allowable shear stress of skin)

    % Geometry
    b = geometry.span;
    c = geometry.chordRoot;
    t = c * 0.125;  % thickness = 12.5% of chord
    l_root = geometry.rootSize;
    b_sw = 0.5 * (b - l_root);  % semi-wing span
    y_bend = t / 2;             % max bending distance
    a = c / 2;                  % ellipse major radius
    b_ellipse = t / 2;          % ellipse minor radius

    num_sections = 5;

    % Lift and load distribution
    L_sw = weight * loadFactor * safetyFactor * g * b_sw / b;
    w_sw = L_sw / b_sw;

    x = linspace(0, b_sw, num_sections);
    V = zeros(1, num_sections);
    M = zeros(1, num_sections);
    I_required_bending = zeros(1, num_sections);
    t_wall_required = zeros(1, num_sections);

    for i = 1:num_sections
        if i == 1
            V(i) = -L_sw;
            M(i) = -L_sw * b_sw / 2;
        else
            V(i) = -L_sw * (1 - x(i)/b_sw);
            M(i) = 0.5 * V(i) * (b_sw - x(i));
        end

        % Required moment of inertia for bending
        I_required_bending(i) = abs(M(i)) * y_bend / sigma_allow;

        % Required skin thickness to resist shear
        t_wall_required(i) = abs(V(i)) / (tau_allow * b_ellipse);
    end
end
