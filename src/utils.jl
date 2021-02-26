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