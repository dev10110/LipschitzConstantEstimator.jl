using LipschitzConstantEstimator
using Documenter

DocMeta.setdocmeta!(LipschitzConstantEstimator, :DocTestSetup, :(using LipschitzConstantEstimator); recursive=true)

makedocs(;
    modules=[LipschitzConstantEstimator],
    authors="Devansh Agrawal <devansh@umich.edu> and contributors",
    sitename="LipschitzConstantEstimator.jl",
    format=Documenter.HTML(;
        canonical="https://dev10110.github.io/LipschitzConstantEstimator.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/dev10110/LipschitzConstantEstimator.jl",
    devbranch="main",
)
