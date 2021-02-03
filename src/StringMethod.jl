module StringMethod

using LinearAlgebra
using Dierckx
using Printf

# utility functions
include("utils.jl")
export periodic_dist

# integration routines
include("integrate.jl")
export stepRK4! 

# reparametrization routines
include("reparametrize.jl")
export  spline_reparametrize!

# string method routines
include("string.jl")
export SimplifiedString

end #end module