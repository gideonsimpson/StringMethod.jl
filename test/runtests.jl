using Test
using LinearAlgebra
using StringMethod
using TestLandscapes
using ForwardDiff

@testset "String Method" begin
    @test include("string1.jl")
end

@testset "Climbing Image Method" begin
    @test include("saddle1.jl")
end

