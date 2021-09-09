"""
`stepEuler!`: Perform an in place Euler step

### Fields
* `u` - Initial state
* `∇V` - Gradient of energy
* `Δt` - Time step
"""
function stepEuler!(u, ∇V::TGV, Δt) where {TGV}
    @. u = u - Δt * ∇V(u);

    u
end

"""
`stepRK4!`: Perform an in place RK4 step

### Fields
* `u` - Initial state
* `∇V` - Gradient of energy
* `Δt` - Time step
"""
function stepRK4!(u, ∇V::TGV, Δt) where {TGV}

    gradV1 = ∇V(u);
    gradV2 = ∇V(u - 0.5 * Δt * gradV1);
    gradV3 = ∇V(u - 0.5 * Δt * gradV2);
    gradV4 = ∇V(u - Δt * gradV3);

    @. u = u - Δt/6 * (gradV1 + 2 * gradV2 + 2 * gradV3 + gradV4);

    u

end

"""
`stepPCEuler!`: Perform an in place Euler step with preconditioning

### Fields
* `u` - Initial state
* `∇V` - Gradient of energy
* `P` - Preconditioner
* `Δt` - Time step
"""
function stepPCEuler!(u, ∇V::TGV, P::TP, Δt) where {TGV, TP}
    
    gradV = ∇V(u);
    Pu = P(u);
    u .= u - Δt * Pu\gradV;

    u
end
