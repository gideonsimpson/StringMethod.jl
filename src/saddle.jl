"""
    ClimbingImage(∇V!, integrate!, dist, Δt)

Set up the Climbing Image Method

### Fields

* ∇V_climb!   - In place gradient of the potential with reflector
* integrate! - In place integrator
* dist - Distance for checking convergence
* Δt    - Time step
"""
struct ClimbingImage{TGVC, TI, TD, TF<:AbstractFloat} <: ClimbingImageMethod
    ∇V_climb!::TGVC
    integrate!::TI
    dist::TD
    Δt::TF
end

"""
`climbing_image`: Run the climbing image method...
### Fields
* `u` - Initial guess for saddle
* `C` - Climbing image data structure
### Optional Fields
"""
function climbing_image(u₀, C::TC; options=SaddleOptions()) where {TC <: ClimbingImage}
    u = copy(u₀)
    u_new = copy(u);

    u_trajectory = typeof(u)[copy(u)];

    err_est = 0.;


    
    for n in 1:options.nmax
        C.integrate!(u_new, C.∇V_climb!, C.Δt);

        err_est =C.dist(u_new, u)
        if(options.verbose && mod(n, options.print_iters)==0)
            @printf("[%d]: error = %g\n", n, err_est);
        end
        copy!(u, u_new);

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
    u_new = copy(u);

    err_est = 0.;

    for n in 1:options.nmax
        C.integrate!(u_new, C.∇V_climb!, C.Δt);

        err_est =C.dist(u_new, u)
        if(options.verbose && mod(n, options.print_iters)==0)
            @printf("[%d]: error = %g\n", n, err_est);
        end

        copy!(u, u_new);
        if (err_est< options.tol)
            break
        end
    end

    if(err_est >= options.tol)
        @printf("ERROR: Did not converge after %d iterartions", options.nmax)
    end
    u
end