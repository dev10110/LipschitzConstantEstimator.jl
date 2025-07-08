# LipschitzConstantEstimator

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://dev10110.github.io/LipschitzConstantEstimator.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://dev10110.github.io/LipschitzConstantEstimator.jl/dev/)
[![Build Status](https://github.com/dev10110/LipschitzConstantEstimator.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/dev10110/LipschitzConstantEstimator.jl/actions/workflows/CI.yml?query=branch%3Amain)



## Quickstart

```@example main
using LipschitzConstantEstimator

# suppose we have the following function 
f(x) = x[1] - x[1]^3 / 3

# define a domain we wish to evaluate over
# defined as IntervalDomain(lower_corner, upper_corner)
domain = IntervalDomain( [-1.0], [1.0])

# run the estimator 
results = estimate_lipschitz_constant(f, domain);

# extract the result
println(results.status)
println(results.L)
```

`results.success` is a boolean, indicating whether `Optim.jl` thinks the problem converged.

`results.L` is the estimated Lipschitz constant, should be close to `1` in this case.

The `results` struct contains additional information that can be useful for debugging. See the documentation. 
See the documentation for additional settings that you can tweak. 

By default, it will call your function 1000 times to estimate the Lipschitz constant. 
