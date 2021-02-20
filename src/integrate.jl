"""
`stepEuler!`: Perform an in place Euler step

### Fields
* `u` - Initial state
* `∇V!` - Gradient of energy
* `Δt` - Time step
"""
function stepEuler!(u, ∇V!::TGV, Δt) where {TGV}
    gradV = similar(u);

    ∇V!(gradV, u);
    @. u = u - Δt * gradV;

    u
end

"""
`stepRK4!`: Perform an in place RK4 step

### Fields
* `u` - Initial state
* `∇V!` - Gradient of energy
* `Δt` - Time step
"""
function stepRK4!(u, ∇V!::TGV, Δt) where {TGV}

    gradV1 = similar(u);
    gradV2 = similar(u);
    gradV3 = similar(u);
    gradV4 = similar(u);

    ∇V!(gradV1, u);
    ∇V!(gradV2, u - 0.5 * Δt * gradV1);
    ∇V!(gradV3, u - 0.5 * Δt * gradV2);
    ∇V!(gradV4, u - Δt * gradV3);

    @. u = u - Δt/6 * (gradV1 + 2 * gradV2 + 2 * gradV3 + gradV4);

    u

end