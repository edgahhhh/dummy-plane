H = 9
W = 72
L = 1.5*W

c = H/2
Givens
Mc = 352*10^3;
    % twisting, lbf-in
Fl = 76*10^3;
Fd = 783;
    % both tip loads, lbf
Sallow = 32*10^3;
    %  allowable stress, psi
FS = 1.5;
    % Factor of safety for loads
adjustedSallow = Sallow * FS
    % Allowable stress w/ factor of safety, psi

% Calculting bending moment from lift
Ml = Fl * L
    % lbf-in

% Young's modulus for aluminium
E = 10600*10^3
    % psi

% Poissoins ratio for alimunium
nu = 0.33

% Density for our aluminium in lbm*in-3
rho = 0.097

Finding stringer geometry
%{
Overview: Unlike previouosly, here we will try to find the geomestries for
our stringers by first letting them take all the bending stress from the
lift. We also will be finding skin thickness by also letting it be able to
withstand the bending stress that comes from the lift as well.
%}

% First lets find the Ixx needed from the lift
Ineed = Ml * c / adjustedSallow
% Lets now find the Ixx of the ribs for later use maybe idk
Irib = W * H^3 / 12

% We can find the thickness of the skin by using symbolics
syms tskin
% Just letting the Ixx of the skins go to Ineed we get
Iskin = 2*(W*H^2*tskin)
tsk = vpasolve(Iskin == Ineed, tskin)

ask = tsk*W

% Lets now find stringer geometries
% Let's use a Z shape for the stringers
% Make conservative assumption that our stringers will
% take all the bending moment from the lift
% Istringer = 2*W/s*as*(H/2)^2, we'll let s = 1 in for now
syms astringer
s = 1/2
Istringer = 2*W/s*astringer*(H/2)^2
ast = vpasolve(Istringer == Ineed, astringer)


% Let our Z stringer have a top and bottom s with a length of 
% 1/2 in and overall height of 1 in
syms tstringer 
% astringer = tstringer*(s+(3/4)+(s/2))
b = 1;
astringer = tstringer*(b+2*(s-tstringer))
tst = vpasolve(astringer == ast, tstringer)
tst = tst(1)

% Lets see how many stringers we'll have in our design
nst = 2*(W-2*0.5) / s
%{
Conclusion: We will be using a skin thickness of 0.066 in
with 288 stringers of a Z channel shape with the dimensions of 
s = 1/2 in and an overall height of 1in with thickness of 0.07 in.
IMPORTANT: This iteration has no spars
%}

Rib Spacing
%{
Overview: Now that we know our stringers geometries, we can find the
parameters for the ribs. Essentially our ribs will be stiffening the
stringers so that they don't buckle and pass our design requirement for
buckling. 
%}
% finding the rib spacing needed

Pcrit = pi^2*E*Ineed / L^2
Pactual = FS*Ml*c/Ineed*(ast)
if Pactual < Pcrit
    disp("Design won't need ribs")
else
Pcrit = Ml*c/Ineed*ast
a = sqrt((pi^2*E*Ineed) / (FS*Pcrit))
end

%{
Conclusion: Current design won't need spars because our stringers won't
buckle at their current iteration.
IMPORTANT: FEA will have to prove this
%}

Spar Spacing
%{
Overview: Same basis as the ribs spacing
%}

Pcrit = pi^2*E*Ineed / W^2
Pactual = Fd+(Mc*W/2/(L*tsk*c^2))
if Pactual < Pcrit
    disp("Design won't need spars")
else
Pcrit = Ml*c/Ineed*ast
a = sqrt((pi^2*E*Ineed) / (FS*Pcrit))
end



Deflection
allow_def = 28;
    % allowable deflection
adjustdef = allow_def/FS
    % allowable deflection after factor of safety

% Ixx calculated to be needed for deflection requirement
Idef = Fl*L^3 / 3 / E / adjustdef   

% calculating deflection from Ixx found
deflection = Fl * L^3 / 3 / E / Ineed

if deflection < adjustdef
    disp("Deflection requirement met")
end


mass rqmt
% Lets create our design
% Box of L = 108in, W = 72in, and H = 9in
% We can design out wing with no stringers, out skins can have geometries
% to withstand the bending stress induced by lift
% Our wing will only have 1/2 in spars as the walls and 0.1in ribs as walls
% as well
mass_skin = 2*ask*L*rho
mass_ribs = 2*0.1*(H-2*tsk)*W*rho
mass_spars = 2*0.1*(H-2*tsk)*L*rho
mass_stringers = ast*(L-0.2)*nst*rho
total_mass = mass_skin+mass_ribs+mass_spars+mass_stringers

if total_mass < 540
    disp("Mass requirement met")
else
    disp("Mass exceeds 540 lbm")
end

mass_skin1=mass_skin;
