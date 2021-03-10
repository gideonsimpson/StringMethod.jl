struct StringOptions
        nmax::Int
        tol::Float64
        verbose::Bool
        save_trajectory::Bool
        print_iters::Int
end

"""
    StringOptions(;nmax = 10^3, tol = 1e-6, verbose = false, save_evolution = true)
"""
function StringOptions(;nmax = 10^3, tol = 1e-6, verbose = false, save_trajectory = true, print_iters = 10^3)
    return StringOptions(nmax, tol, verbose, save_trajectory, print_iters)
end

struct SaddleOptions
        nmax::Int
        tol::Float64
        verbose::Bool
        save_trajectory::Bool
        print_iters::Int
end
"""
    SaddleOptions(;nmax = 10^3, tol = 1e-6, verbose = false, save_trajectory = true, print_iters = 10^3)
"""
function SaddleOptions(;nmax = 10^3, tol = 1e-6, verbose = false, save_trajectory = true, print_iters = 10^3)
    return SaddleOptions(nmax, tol, verbose, save_trajectory, print_iters)
end

"""
`periodic_dist`: Compute the periodic distance between values

### Fields
* `u` - First point on the periodic interval
* `v` - Second point on the periodic interval
### Optional Fields
* `Π = 1.0` - Period of the interval, [0, Π)
"""
function periodic_dist(u,v; Π = 1.0)
    return min(abs(u-v), Π- abs(u-v))
end

"""
`linear_string` - Construct the linear interpolant string between x₀ and x₁ with
a given number of images (inclusive).

### Fields
* `x₀` - Initial image on the string
* `x₁` - Final image on the string
* `n_images` - Total number of images on the string, including x₀ and x₁
"""
function linear_string(x₀, x₁, n_images)
    
    X = typeof(x₀)[];
    x = similar(x₀);

    for j in 0:n_images-1
        t = Float64(j/(n_images-1));
        @. x = (1. - t) * x₀ + t * x₁;
        push!(X, copy(x));
    end
    return X

end

"""
`upwind_tangent` - Estimate the tangent vector from a string's interior using
an upwinding method

### Fields
* `U` - Array of three images, in sequence, along the string
* `V` - Potential energy defining the landscape
"""

function upwind_tangent(U, V)
    V_vals = V.(U);
    if (V_vals[1]<V_vals[2] && V_vals[2]< V_vals[3])
        τ = (U[3] .- U[2])/norm(U[3] .- U[2]);
    elseif (V_vals[1]>V_vals[2] && V_vals[2]> V_vals[3])
        τ = (U[2] .- U[1])/norm(U[2] .- U[1]);
    else
        τ = (U[3] .- U[1])/norm(U[3] .- U[1]);
    end

    return τ
end