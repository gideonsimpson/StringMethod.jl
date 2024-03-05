using Documenter
using Pkg
Pkg.develop(path="..");
Pkg.instantiate();
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
