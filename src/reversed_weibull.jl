

"""
    RevWeibull3P

A three-parameter reversed Weibull distribution, parameterized by scale `λ`, shape `k`, and location `μ`.
This distribution is defined for `x < μ`, and it has a maximum at `μ`.
"""
struct RevWeibull3P{T<:Real} <: ContinuousUnivariateDistribution
    λ::T  # scale
    k::T  # shape
    μ::T  # location (maximum)
end

"""
    logpdf(d::RevWeibull3P, x::Real)
Compute the logarithm of the probability density function for the reversed Weibull distribution at `x`.
The distribution is defined for `x < μ`, and it returns `-Inf` for `x >= μ`.
"""
function Distributions.logpdf(d::RevWeibull3P, x::Real)
    λ, k, μ = d.λ, d.k, d.μ
    if x >= μ # || λ <= 0 || k <= 0 # these cases cant happen by construction of RevWeibull3P
        return -Inf
    end
    z = (μ - x) / λ
    return log(k / λ) + (k - 1) * log(z) - z^k
end

"""
    pdf(d::RevWeibull3P, x::Real)
Compute the probability density function for the reversed Weibull distribution at `x`.
If `x >= μ`, it returns `1.0`, otherwise it computes the PDF using the `logpdf` function.
"""
function Distributions.pdf(d::RevWeibull3P, x::Real)
    if x >= d.μ
        return 1.0
    else
        return exp(logpdf(d, x))
    end
end


"""
    cdf(d::RevWeibull3P, x::Real)
Compute the cumulative distribution function for the reversed Weibull distribution at `x`.
If `x >= μ`, it returns `1.0`, otherwise it computes the CDF using the formula:
```math
\\operatorname{cdf}(x) = \\begin{cases}
 \\exp\\left(-\\left(\\frac{μ - x}{λ}\\right)^k\\right) & \\text{if } x < μ \\\\
 1 & \\text{if } x \\geq μ
\\end{cases}
```
This is slightly different from the form in Wood's paper, as the scale parameter is inside the exponent.
"""
function Distributions.cdf(d::RevWeibull3P, x::Real)
    # slightly different form than what Wood has in his paper
    x >= d.μ ? 1.0 : exp(-((d.μ - x) / d.λ)^d.k)
end

function Base.rand(d::RevWeibull3P)
    u = rand()
    d.μ - d.λ * (-log(u))^(1 / d.k)
end

"""
    negloglik(params, data)
Compute the negative log-likelihood for the reversed Weibull distribution given parameters `params` and data `data`.
The parameters are expected to be in the form `[λ, k, μ]`, where `λ` is the scale, `k` is the shape, and `μ` is the location (maximum).
The function returns `Inf` if the parameters are invalid (e.g., if `λ <= 0`, `k <= 0`, or `μ <= maximum(data)`).
"""
function negloglik(params, data)
    λ, k, μ = params
    if λ <= 0 || k <= 0 || μ <= maximum(data)
        return Inf
    end
    dist = RevWeibull3P(λ, k, μ)
    return -sum(logpdf.(dist, data))
end

"""
    fit_reversed_weibull(data, initial_guess = [1.0, 1.0, 1.01 * maximum(data)]; alg=NelderMead(), kwargs...)
Fit a reversed Weibull distribution to the given `data` using maximum likelihood estimation.
The function uses the `negloglik` function to compute the negative log-likelihood and optimizes it using the `optimize` function from the Optim package.
The `initial_guess` parameter specifies the initial values for the parameters `[λ, k, μ]`, where `λ` is the scale, `k` is the shape, and `μ` is the location (maximum).
The default initial guess is `[1.0, 1.0, 1.01 * maximum(data)]`, which ensures that `μ` is greater than the maximum value in the data.
The optimization algorithm can be specified using the `alg` parameter, with `NelderMead()` as the default.
Additional keyword arguments can be passed to the `optimize` function.
"""
function fit_reversed_weibull(data, initial_guess = [1.0, 1.0, 1.01 * maximum(data)]; alg=LBFGS(), kwargs...)

    # Optimize
    result = optimize(p -> negloglik(p, data), initial_guess, alg; kwargs...)

    params_hat = Optim.minimizer(result)
    fitted_dist = RevWeibull3P(params_hat...)

    return result, fitted_dist

end