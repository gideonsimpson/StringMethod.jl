#push!(LOAD_PATH, "../src/")
using Documenter
using Pkg
Pkg.develop(path="../../StringMethod.jl/")
using StringMethod
makedocs(checkdocs=:none,
    sitename="StringMethod.jl",
    modules=[StringMethod],
    pages=[
        "Home" => "index.md",
        "String Method" =>"string1.md",
        "Climbing Image Method" => "climb1.md",
    ])
deploydocs(;
    repo="github.com/gideonsimpson/StringMethod.jl",
)
