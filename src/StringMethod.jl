module StringMethod

using LinearAlgebra
using DataInterpolations
using Printf

# types
include("types.jl")

# utility functions
include("utils.jl")
export StringOptions, SaddleOptions, periodic_dist, linear_string, upwind_tangent

# integration routines
include("integrate.jl")
export stepEuler!, stepRK4!

# reparametrization routines
include("reparameterize.jl")
export  spline_reparametrize!

# string method routines
include("string.jl")
export SimplifiedString, simplified_string, simplified_string!

# saddle point method routines
include("saddle.jl")
export ClimbingImage, climbing_image, climbing_image!
end #end module