using Disyuntivo
using Documenter

makedocs(;
    modules=[Disyuntivo],
    authors="Edward Angelino",
    repo="https://github.com/EdwardAngelino/Disyuntivo.jl/blob/{commit}{path}#L{line}",
    sitename="Disyuntivo.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://EdwardAngelino.github.io/Disyuntivo.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/EdwardAngelino/Disyuntivo.jl",
)
