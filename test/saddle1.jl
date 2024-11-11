U = U_trajectory[end];
max_idx = argmax(V.(U));
τ = upwind_tangent(U[max_idx-1:max_idx+1], V);

climb = ClimbingImage(∇V, τ, stepRK4!, 1e-4);
opts = SaddleOptions(verbose=true, save_trajectory=false, tol=1e-8)

saddle_trajectory = climbing_image(U[max_idx], climb, options=opts)

saddle_pt = [-0.8220015599478441, 0.6243128012695888];

norm(saddle_trajectory[end] - saddle_pt) < 1e-8