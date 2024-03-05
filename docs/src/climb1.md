# Climbing Image method

```@contents
Pages = ["climb1.md"]
```

Having construct a minimum energy path joining two states, we often want to find the saddle point joining them.  Here, we have implemented the climbing image method as described in E, Ren, and Vanden-Eijnden (2007).

## Identify Candidate Saddle
The first step of the climbing image method is to identify a vector that points from one of the images, roughly, towards the saddle.  This can be done by:
* Finding the highest energy image along the string.  This is neareest the highest energy saddle.
* Using the highest energy image along with two neighbors to construct an
  estimate of the vector pointing in the unstable direction of the saddle point.
  Or, more practically, construct a vector that is sufficiently collinear to the
  unstable direction.

For example, for string `U`, the following computes this vector, storing it in `τ`:
```
max_idx = argmax(V.(U));
τ = upwind_tangent(U[max_idx-1:max_idx+1], V)
```


## Set up Climbing Image Solver
Having identified the direction ``\tau``, we then sep the climbing image solver with
```@docs
    ClimbingImage
```

## Set Options
Analogously to the string method, we can set solver options with respect to number of iterations, toleranace, etc. with
```@docs
    SaddleOptions
```

## Solve
Having set the desired parameters, we execute
```@docs
    climbing_image
```

## Example
```@example
using Test
using LinearAlgebra
using StringMethod
using TestLandscapes
using ForwardDiff
using Printf
using Plots

# set potential and get its gradient
V = x -> Muller(x);
∇V = x -> ForwardDiff.gradient(V, x);

U0 = linear_string([0, -0.25], [0, 1.5], 15)

Δt = 1e-4;
dist = (u, v) -> norm(u - v, 2);
pin = false;

string = SimplifiedString(∇V, stepRK4!, spline_reparametrize!, dist, pin, Δt);
opts = StringOptions(verbose=false, save_trajectory=false)

# solve
U_trajectory = simplified_string(U0, string, options=opts);
U=U_trajectory[end];

# saddle point search
max_idx = argmax(V.(U));
τ = upwind_tangent(U[max_idx-1:max_idx+1], V);
climb = ClimbingImage(∇V,τ, stepRK4!, 1e-4);
opts = StringMethod.SaddleOptions(save_trajectory=false);
u_trajectory = climbing_image(U[max_idx], climb, options=opts);
saddle_pt = u_trajectory[end];

# visualize
xx =LinRange(-1.5, 1.5,150);
yy = LinRange(-0.5, 2.0,150);
V_vals = [V([x,y]) for y in yy, x in xx];

plt = contour(xx,yy,min.(V_vals,500),
levels = LinRange(-150,500,50),color=:viridis,colorbar_title="V")
scatter!(plt, [x_[1] for x_ in U],  
        [x_[2] for x_ in U],color=:red, label="String")
scatter!(plt, [saddle_pt[1]], [saddle_pt[2]], 
    color=:orange, markershape=:star5, label="Saddle")
xlabel!("x")
ylabel!("y")
```