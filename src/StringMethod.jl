module StringMethod

using LinearAlgebra
using Dierckx
using Printf


# integration routines
include("integrate.jl")

# reparametrization routines
include("reparametrize.jl")

# string method routines
include("string.jl")
export SimplifiedString

end #end module