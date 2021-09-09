module StringMethod

using LinearAlgebra
using Dierckx
using Printf

# types
include("types.jl")

# utility functions
include("utils.jl")
export StringOptions, SaddleOptions, periodic_dist, linear_string, upwind_tangent

# integration routines
include("integrate.jl")
export stepEuler!, stepRK4!, stepPCEuler!

# reparametrization routines
include("reparameterize.jl")
export  spline_reparametrize!

# string method routines
include("string.jl")
include("pcstring.jl")
export SimplifiedString, PCSimplifiedString, simplified_string, simplified_string!

# saddle point method routines
include("saddle.jl")
export ClimbingImage, climbing_image, climbing_image!
end #end module