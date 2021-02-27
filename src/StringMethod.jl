module StringMethod

using LinearAlgebra
using Dierckx
using Printf

# types
include("types.jl")

# utility functions
include("utils.jl")
export StringOptions, periodic_dist, linear_string

# integration routines
include("integrate.jl")
export stepEuler!, stepRK4! 

# reparametrization routines
include("reparameterize.jl")
export  spline_reparametrize!

# string method routines
include("string.jl")
export SimplifiedString, simplified_string, simplified_string!

end #end module