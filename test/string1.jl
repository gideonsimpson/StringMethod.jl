V = x -> Muller(x);
∇V = x -> ForwardDiff.gradient(V, x);

U0 = linear_string([0, -0.25], [0, 1.5], 101)

Δt = 1e-4;
dist = (u, v) -> norm(u-v, 2);
pin = false;

string = SimplifiedString(∇V, stepRK4!, spline_reparametrize!, dist, pin, Δt);
opts = StringOptions(verbose=true, save_trajectory=false, tol=1e-8)

U_trajectory = simplified_string(U0, string, options=opts);

mid_pt = [-0.5352369130791, 0.5051729517334016]; # precomputed

norm(U_trajectory[end][51] - mid_pt) < 1e-8
