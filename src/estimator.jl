
"""
    create_lipschitz_estimates(f, domain::AbstractDomain, n=10, m=200, δ=0.05)
Create estimates of the Lipschitz constant for a function `f` over a given `domain`.
The function samples pairs of points from the domain, computes the Lipschitz constant for each pair
and returns a vector of estimates.
- `f`: the function for which the Lipschitz constant is to be estimated.
- `domain`: an instance of `AbstractDomain` defining the bounds for sampling.
- `n`: number of samples to take for each estimate (default is 10).
- `m`: number of estimates to create (default is 200).
- `δ`: the distance within which to sample pairs of points (default is 0.05).
The function returns a vector of `m` estimates of the Lipschitz constant.
"""
function create_lipschitz_estimates(f, domain::AbstractDomain, n=10, m=200, δ=0.05)

    @assert δ > 0
    
    # get each l
    ls = zeros(m)

    # create m estimates of the lipschtiz constant
    for i=1:m
        # take the max over n samples
        for j=1:n
            x1, x2 = sample_pair(domain, δ)

            z1 = f(x1)
            z2 = f(x2)

            L = norm(z1- z2) / norm(x1 - x2)
            
            ls[i] = max(ls[i], L)
        end
    end

    # fit a reverse weibull distribution
    return ls
    
end


"""
    estimate_lipschitz_constant(f, domain::AbstractDomain, n=10, m=200, δ=0.05; alg = NelderMead(), kwargs...)
Estimate the Lipschitz constant for a function `f` over a given `domain`.
The function samples pairs of points from the domain, computes the Lipschitz constant for each pair
and fits a reversed Weibull distribution to the estimates.
- `f`: the function for which the Lipschitz constant is to be estimated.
- `domain`: an instance of `AbstractDomain` defining the bounds for sampling.
- `n`: number of samples to take for each estimate (default is 10). 
- `m`: number of estimates to create (default is 200).
- `δ`: the distance within which to sample pairs of points (default is 0.05).
- `alg`: the optimization algorithm to use for fitting the reversed Weibull distribution (default is `NelderMead()`).
- `kwargs`: additional keyword arguments to pass to the optimization function.
The function returns a tuple containing
- a boolean indicating whether the optimization converged
- the estimated Lipschitz constant
- the result struct from Optim.jl 
- the fitted reversed Weibull distribution parameters.
The Lipschitz constant is estimated as the location parameter `μ` of the fitted reversed Weibull distribution.
"""
function estimate_lipschitz_constant(f, domain::AbstractDomain, n=10, m=200, δ=0.05; alg = LBFGS(), kwargs...)

    ls = create_lipschitz_estimates(f, domain, n, m, δ)
    initial_guess = [1.0, 1.0, 0.01 + 1.01 * maximum(ls)]
    optim_status, optim_result = fit_reversed_weibull(ls, initial_guess; alg=alg, kwargs...)
    
    return Optim.converged(optim_status), optim_result.μ, optim_status, optim_result

end