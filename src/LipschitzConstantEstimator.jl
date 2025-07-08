module LipschitzConstantEstimator

using LinearAlgebra, StaticArrays, Distributions, Optim

export IntervalDomain, RevWeibull3P, estimate_lipschitz_constant

include("domains.jl")
include("reversed_weibull.jl")
include("estimator.jl")

end
