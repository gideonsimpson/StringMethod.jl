"""
`SimplifiedString`: Run the simplified string method for an energy landscape
with forcing term F = -∇E impelmented as in place transform with a user
specified integrator and reparametrization.  Performance is checked with a user
specified distance function.

### Fields
* `U₀` - Initial string
* `F!` - Driving force on the model written as an in place transform
* `integrate!` - Algorithmic time stepper
* `reparameterize!` - String reparametrization
* `dist` - Distance function
  ### Optional Fields
* `nmax = 100` - Maximum number of time steps
* `τ = 1e-6` - Termination tolerance
* `verbose = false` - Verbosity of output
"""

function SimplifiedString(U₀, F!::TF, integrate!::TI, reparameterize!::TR, dist::TD; nmax=100, τ = 1e-6, verbose = false)
    U = deepcopy(U₀);
    U_new = deepcopy(U);

    n_images = length(U);
    Δs = 1/(n_images-1);
    err_est = 0.;

    for n in 1:nmax
        # time stepping routine
        integrate!.(U_new, F!);

        # reparametrization step
        reparameterize!(U_new)

        err_est = maximum([norm(dist.(U_new[i], U[i])) for i in 1:n_images])/Δt;
        if(verbose)
            @printf("[%d]: error = %g\n", n, err_est);
        end

        copy!.(U, U_new);
        if (err_est< τ)
            break
        end
    end

    if(err_est >= τ)
        @printf("ERROR: Did not converge after %d iterartions", nmax)
    end

    return U

end