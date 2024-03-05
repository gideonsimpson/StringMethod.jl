# String Method

```@contents
Pages = ["string1.md"]
Depth = 4

```


Recall that in the string method, one seeks to find a mapping function
```math
   \varphi(\alpha):[0,1]\to \mathbb{R}^d, \quad \varphi(0)= x_-, \quad \varphi(1) = x_+,
```
where $x_\pm$ are initial and terminal points which often (but not always)
correspond to local minima on the energy landscape.  While many such ``\varphi``
are possible, the string method identifies a _minimum energy path_ accomplishing
this transition.  Here, we implement the (simplified and improved) string method, as described in E, Ren, and Vanden-Eijnden (2007).

## Initialize String
To apply the string method, we must first initialize the string, which is to
say, specifcy sequence of images joining two (approximate) minima must be given.
``\{varphi^{(i)}\}``, where ``\varphi^{(i)} \approx \varphi(\alpha_i)``.  This
is anticipated to be a structure of the type `Vector{Vector{Float64}}` where the
interior `Vector{Float64}` structure reflect the points residing in
``\mathbb{R}^d``.

A convenience function is provided that constructs a linear interpolant,
```@docs
    linear_string
```
An example of running such a code is:
```@example
using StringMethod

x_init = [1.5, -0.5];
x_final = [-0.5, 1.0];
n_images = 11;

U = linear_string(x_init, x_final, n_images)
```
## Construct String Method Solver
There are several ingredients that go into running the string method:
* Time stepping scheme and `Δt`, the time step
* The reparamertization scheme
* A distance function used by the reparameterization and also for checking convergence

These are invoked with the structure:
```@docs
SimplifiedString
```

### Time Stepping
Time stepping is handled by the in place `integrate!(x, ∇V, Δt)` which advances the ODE ``\dot{x} = -\nabla V(x)`` by time ``\Delta t``.  There are two built in options, though others can be added:
```@docs
stepEuler!
stepRK4!
```

### Reparametrization and Distance
The string is reparamertrized with `reparameterize!(U, dist, pin)`.  This maps the current set of images ``\{\varphi^{(i)}_\ast\}`` to a new set ``\{\varphi^{(i)}\}`` such that, with respect to the `dist` function, the images are uniformly distributed,  i.e., after the function is applied
```math
\mathrm{dist}(\varphi^{(i)}, \varphi^{(i+1)}) = \text{Constant in $i$}
```  

Currently, the only version implemented makes use of cubic splines as part of the `Dierckx` package:
```@docs
spline_reparametrize!
```

The boolean `pin` argument refers to whether the initial and final images on the string should be treated as _pinned_ (`true`) or not (`false`).

The distnace function, `dist(x,y)` should be suitable for the problem.

## Set Solver Options
In addition to the string method options, we also have the numerical options associated with the number of iterations to perform, stopping tolerance, etc.  These are set by constructing:
```@docs
StringOptions
```

## Solve
Having set everything, we execute
```@docs
simplified_string
```

## Example
The following example applies the string method to the Muller (sometimes Muller-Brown) potential, a 2D energy landscape often used to demonstrate algorithms.  Muller-Brown is coded in the `TestLandscapes.jl` package.
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
opts = StringOptions(verbose=false, save_trajectory=true)

# solve
U_trajectory = simplified_string(U0, string, options=opts);

# visualize
xx =LinRange(-1.5, 1.5,150);
yy = LinRange(-0.5, 2.0,150);
V_vals = [V([x,y]) for y in yy, x in xx];

anim =@animate for i in 1:10:length(U_trajectory)
    plt = contour(xx,yy,min.(V_vals,500),
        levels = LinRange(-150,500,50),color=:viridis,colorbar_title="V")
    scatter!(plt, [x_[1] for x_ in U_trajectory[i]],  
        [x_[2] for x_ in U_trajectory[i]],color=:red, label="String")
    xlabel!("x")
    ylabel!("y")

    title!(plt, @sprintf("Iteration %d", i-1))
end
gif(anim, fps=15)

```