"""
`SimplifiedString(∇V!, integrate!, reparameterize!, dist, Δt)` -  Set up the
simplified string method data structure

### Fields

* `∇V!`   - In place gradient of the potential
* `integrate!` - Integrator for ẋ = - ∇V(x)
* `reparameterize!` - Choice of reparametrization
* `dist` - Distance function used in reparametrization and convergence testing
* `pin` - Boolean for pinning the endpoints of hte string
* `Δt`    - Time step for the integrator
"""
struct SimplifiedString{TGV, TI, TR, TD, TP<:Bool, TF<:AbstractFloat} <: SimplifiedStringMethod
    ∇V!::TGV
    integrate!::TI
    reparameterize!::TR
    dist::TD
    pin::TP
    Δt::TF
end

"""
`simplified_string` - Run the simplified string method for an energy landscape
set up with the `SimplifiedString` data structure.  This can return the entire
string evolution.

### Fields
* `U` - Initial string
* `S` - Simplified string data structure
  ### Optional Fields
* `options` - String method options
"""
function simplified_string(U₀, S::TS; options=StringOptions()) where {TS <: SimplifiedString}
    U = deepcopy(U₀)
    U_new = deepcopy(U);

    U_trajectory = typeof(U)[deepcopy(U)];

    n_images = length(U);
    Δs = 1/(n_images-1);
    err_est = 0.;

    for n in 1:options.nmax
        # time stepping routine
        if S.pin
            S.integrate!.(U_new[2:end-1], S.∇V!, S.Δt);
        else
            S.integrate!.(U_new, S.∇V!, S.Δt);
        end
        # reparametrization step
        S.reparameterize!(U_new, S.dist, S.pin)

        err_est = maximum([S.dist(U_new[i], U[i]) for i in 1:n_images])/S.Δt;
        if(options.verbose && mod(n, options.print_iters)==0)
            @printf("[%d]: error = %g\n", n, err_est);
        end

        copy!.(U, U_new);
        if(options.save_trajectory)
            push!(U_trajectory, deepcopy(U));
        end
        if (err_est< options.tol)
            if(!options.save_trajectory)
                push!(U_trajectory, deepcopy(U));
            end
            break
        end
    end

    if(err_est >= options.tol)
        @printf("ERROR: Did not converge after %d iterartions", options.nmax)
    end
    return U_trajectory
end

"""
`simplified_string!` - Run the simplified string method for an energy landscape
set up with the `SimplifiedString` data structure.  This is an in place transform.

### Fields
* `U` - Initial string
* `S` - Simplified string data structure
  ### Optional Fields
* `options` - String method options
"""
function simplified_string!(U, S::TS; options=StringOptions()) where {TS <: SimplifiedString}
    U_new = deepcopy(U);

    n_images = length(U);
    Δs = 1/(n_images-1);
    err_est = 0.;

    for n in 1:options.nmax
        # time stepping routine
        if S.pin
            S.integrate!.(U_new[2:end-1], S.∇V!, S.Δt);
        else
            S.integrate!.(U_new, S.∇V!, S.Δt);
        end
        # reparametrization step
        S.reparameterize!(U_new, S.dist, S.pin)

        err_est = maximum([S.dist(U_new[i], U[i]) for i in 1:n_images])/S.Δt;
        if(options.verbose && mod(n, options.print_iters)==0)
            @printf("[%d]: error = %g\n", n, err_est);
        end

        copy!.(U, U_new);
        if (err_est< options.tol)
            break
        end
    end

    if(err_est >= options.tol)
        @printf("ERROR: Did not converge after %d iterartions", options.nmax)
    end
    U
end