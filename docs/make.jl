using Dirac
using Documenter

makedocs(;
    modules=[Dirac],
    authors="Stefanos Carlström <stefanos.carlstrom@gmail.com> and contributors",
    repo="https://github.com/jagot/Dirac.jl/blob/{commit}{path}#L{line}",
    sitename="Dirac.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jagot.github.io/Dirac.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jagot/Dirac.jl",
)
