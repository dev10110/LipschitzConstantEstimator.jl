```@meta
CurrentModule = LipschitzConstantEstimator
```

# LipschitzConstantEstimator

Documentation for [LipschitzConstantEstimator](https://github.com/dev10110/LipschitzConstantEstimator.jl).

This package provides a function to estimate the lipschitz constant of a function numerically. 

## Example
```@example main
using LipschitzConstantEstimator
# suppose we have the following function 
f(x) = x[1] - x[1]^3 / 3

# define a domain we wish to evaluate over
domain = IntervalDomain( [-1.0], [1.0])
# defined as IntervalDomain(lower_corner, upper_corner)

# run the estimator
results = estimate_lipschitz_constant(f, domain);

# check the success code (should be true)
results.success
```

```@example main
# get the estimated Lipschitz constant (should be close to 1)
results.L
```

```@example main 
# check the optimization status
results.optim_status
```

```@example main
# get the fitted weibull distribution
results.fitted_weibull
```

```@example main
# get the individual samples of lipschitz constants used to fit the weibull
results.samples
```

There are a few parameters to choose for the `estimate_lipschitz_constant` function, see the API below. 

## Algorithm

The basic algorithm is described in
```bibtex
@article{wood1996estimation,
  title={Estimation of the Lipschitz constant of a function},
  author={Zhang, BP},
  journal={Journal of Global Optimization},
  volume={8},
  pages={91--103},
  year={1996},
  publisher={Springer}
}
```

The api we have provided allows for ``f: \R^d \to \R^p`` where ``d, p \geq 1`` can be one or greater. Note, the original paper only analyzes the case where ``d = p = 1``. 

## Public API
```@autodocs
Modules = [LipschitzConstantEstimator]
Private = false
```


## Private API
```@autodocs
Modules = [LipschitzConstantEstimator]
Public = false
```
