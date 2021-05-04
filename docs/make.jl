using DiracQC
using Documenter

makedocs(;
    modules=[DiracQC],
    authors="Stefanos Carlström <stefanos.carlstrom@gmail.com> and contributors",
    repo="https://github.com/jagot/DiracQC.jl/blob/{commit}{path}#L{line}",
    sitename="DiracQC.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jagot.github.io/DiracQC.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jagot/DiracQC.jl",
)
