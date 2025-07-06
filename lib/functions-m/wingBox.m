function () = wingBox(height, width, length_ , twistMoment, lift, drag, stressAllowable, E_material, nu_material, rho_material, safetyFactor)


% Inputs evaluation
h = height;
w = width;
l = length_;
Mc = twistMoment;
L = lift;
D = drag;
Sa = stressAllowable;
E = E_material;
nu = nu_material;
rho = rho_material;
FS = safetyFactor;


c = h/2;
Sadj = Sa * FS;

Ml = L*l;

Ixx_lift = Ml * c / Sadj;
Ixx_rib = w * h^3 / 12;
if Ixx_lift > Ixx_rib
    t_skin = Ixx_lift / 2 / w * h^(-2);
else
    t_skin = Ixx_rib / 2 / w * h^(-2);
end
a_skin = t_skin * w;


end