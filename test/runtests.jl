using LipschitzConstantEstimator
using Test
using StaticArrays, LinearAlgebra, Distributions, Optim

LCE = LipschitzConstantEstimator

@testset "LipschitzConstantEstimator.jl" begin

    @testset "IntervalDomain" begin
        # Test the IntervalDomain functionality
        domain = IntervalDomain([0.0, 0.0], [1.0, 1.0])
        @test LCE.in_domain(domain, SVector(0.5, 0.5))
        @test !LCE.in_domain(domain, SVector(1.5, 0.5))
        @test !LCE.in_domain(domain, SVector(0.5, 1.5))
        @test !LCE.in_domain(domain, SVector(1.5, 1.5))
        @test LCE.in_domain(domain, SVector(0.0, 0.0))
    end

    @testset "ReversedWeibull" begin
        # Test the ReversedWeibull functionality
        # define a reversed weibull distribution
        dist = RevWeibull3P(1.0, 2.0, 3.0)
        @test cdf(dist, 0.0) ≈ 0.00012340980408667956
        @test cdf(dist, 2.0) ≈ 0.36787944117144233
        @test cdf(dist, 3.0) ≈ 1.0

        # test cdf using analytic formula
        for x = -1.0:0.1:3.5
            @test cdf(dist, x) ≈ (x > 3.0 ? 1.0 : exp(-((dist.μ - x) / dist.λ)^dist.k))
        end

        # generate a bunch of samples
        samples = [rand(dist) for _ = 1:1000]
        # fit a reversed weibull distribution to the samples
        success, fitted_dist = LCE.fit_reversed_weibull(samples)

        @test Optim.converged(success)
        @test fitted_dist.λ > 0
        @test fitted_dist.k > 0
        @test fitted_dist.μ > maximum(samples)
        @test fitted_dist.μ ≈ 3.0 atol=0.1

    end

    @testset "Estimator" begin
        # Test the Estimator functionality


        f(x) = x[1] - x[1]^3/3
        domain = IntervalDomain([0.0, 0.0], [1.0, 1.0])

        # Estimate the Lipschitz constant for f1
        result = estimate_lipschitz_constant(f, domain)
        @test result.success
        μ = result.L
        @test μ > 0.0
        @test μ ≈ 1.0 atol=0.1
        @test μ < 2.0  # Lipschitz constant should be less than 2 for this function

    end

end
