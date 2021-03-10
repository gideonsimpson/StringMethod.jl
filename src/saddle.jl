"""
`ClimbingImage(∇V!, τ, ∇V_climb!,integrate!, dist, Δt)` - Set up the Climbing Image Method

### Fields
* `∇V!`   - In place gradient of the potential
* `τ` - Approximate tangent vector of the unstable direction
* `∇V_climb!   `- In place gradient of the potential with reflector
* `integrate!` - In place integrator
* `Δt`    - Time step
"""
struct ClimbingImage{TGV, TT, TGVC, TI, TF<:AbstractFloat} <: ClimbingImageMethod
    ∇V!::TGV
    τ::TT
    ∇V_climb!::TGVC
    integrate!::TI
    Δt::TF
end

function ClimbingImage(∇V!::TGV, τ::TT, integrate!::TI, Δt::TF) where{TGV, TT, TI, TF}
    function ∇V_climb!(gradV, x)
        ∇V!(gradV, x);
        gradV .-= 2 * (gradV⋅τ) * τ
        gradV
    end

    return ClimbingImage(∇V!, τ, ∇V_climb!, integrate!, Δt);
end

"""
`climbing_image`: Run the climbing image method...
### Fields
* `u` - Initial guess for saddle
* `C` - Climbing image data structure
### Optional Fields
"""
function climbing_image(u₀, C::TC; options=SaddleOptions()) where {TC <: ClimbingImage}
    u = copy(u₀);
    gradV = copy(u);

    u_trajectory = typeof(u)[copy(u)];

    err_est = 0.;

    for n in 1:options.nmax
        C.integrate!(u, C.∇V_climb!, C.Δt);
        C.∇V!(gradV, u);
        err_est =norm(gradV);
        if(options.verbose && mod(n, options.print_iters)==0)
            @printf("[%d]: error = %g\n", n, err_est);
        end

        if(options.save_trajectory)
            push!(u_trajectory, copy(u));
        end
        if (err_est< options.tol)
            if(!options.save_trajectory)
                push!(u_trajectory, copy(u));
            end
            break
        end
    end

    if(err_est >= options.tol)
        @printf("ERROR: Did not converge after %d iterartions", options.nmax)
    end
    return u_trajectory
end

"""
`climbing_image!`: Run the climbing image method...
### Fields
* `u` - Initial guess for saddle
* `C` - Climbing image data structure
### Optional Fields
"""
function climbing_image!(u, C::TC; options=SaddleOptions()) where {TC <: ClimbingImage}
    gradV = copy(u);
    
    err_est = 0.;

    for n in 1:options.nmax
        C.integrate!(u, C.∇V_climb!, C.Δt);
        C.∇V!(gradV, u);
        err_est =norm(gradV);
        if(options.verbose && mod(n, options.print_iters)==0)
            @printf("[%d]: error = %g\n", n, err_est);
        end
        if (err_est< options.tol)
            break
        end
    end

    if(err_est >= options.tol)
        @printf("ERROR: Did not converge after %d iterartions", options.nmax)
    end
    u
end