"""
`stepEuler!`: Perform an in place Euler step

### Fields
* `u` - Initial state
* `f!` - Autonomous right hand side function, 
* `Δt` - Time step
"""
function stepRK4!(u, f!::TF, Δt) where {TF}
    f = similar(u);

    f!(f, u);
    @. u = u + Δt *f;

    u
end

"""
`stepRK4!`: Perform an in place RK4 step

### Fields
* `u` - Initial state
* `f!` - Autonomous right hand side function, 
* `Δt` - Time step
"""
function stepRK4!(u, f!::TF, Δt) where {TF}

    f1 = similar(u);
    f2 = similar(u);
    f3 = similar(u);
    f4 = similar(u);

    f!(f1, u);
    f!(f2, u + 0.5 * Δt * f1);
    f!(f3, u + 0.5 * Δt * f2);
    f!(f4, u + Δt * f3);

    @. u = u + Δt/6 * (f1 + 2 * f2 + 2 * f3 + f4);

    u

end