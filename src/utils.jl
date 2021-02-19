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