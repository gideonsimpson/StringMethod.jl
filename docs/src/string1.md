# String Method

Recall that in the string method, one seeks to find a mapping function
```math
   \varphi(\alpha):[0,1]\to \mathbb{R}^d, \quad \varphi(0)= x_-, \quad \varphi(1) = x_+,
```
where $x_\pm$ are initial and terminal points which often (but not always)
correspond to local minima on the energy landscape.  While many such ``\varphi``
are possible, the string method identifies a _minimum energy path_ accomplishing
this transition. 

## Initialize String
To apply the string method, we must first initialize the string, which is to
say, specifcy sequence of images joining two (approximate) minima must be given.
``\{varphi^{(i)}\}``, where ``\varphi^{(i)} \approx \varphi(\alpha_i)``.  This
is anticipated to be a structure of the type `Vector{Vector{Float64}}` where the
interior `Vector{Float64}` structure reflect the points residing in
``\mathbb{R}^d``.

A convenience function is provided that constructs a linear interpolant,
```@docs
    linear_string
```
An example of running such a code is:
```@example
using StringMethod

x_init = [1.5, -0.5];
x_final = [-0.5, 1.0];
n_images = 11;

U = linear_string(x_init, x_final, n_images)
```

## Set Solver Options
TBW

## Solve
TBW