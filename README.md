# Disyuntivo

Utilizacion (en Julia 1.0.5):

Instalación:

(v1.0) pkg> add https://github.com/EdwardAngelino/Disyuntivo.jl
julia> using Disyuntivo

Uso:
julia> leedatostxt("datosdisyuntivo.txt")     # archivo de datos ver archivos de ejemplo
julia> Disyuntivo.optimizar()                 # optimización Requiere instalacion de CPLEX y CPLEX e julia.
julia> Disyuntivo.escriberesultados()         # escribe archivos csv: lineas_res.csv, barras_res.csv


[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://EdwardAngelino.github.io/Disyuntivo.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://EdwardAngelino.github.io/Disyuntivo.jl/dev)
[![Build Status](https://github.com/EdwardAngelino/Disyuntivo.jl/workflows/CI/badge.svg)](https://github.com/EdwardAngelino/Disyuntivo.jl/actions)
[![Coverage](https://codecov.io/gh/EdwardAngelino/Disyuntivo.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/EdwardAngelino/Disyuntivo.jl)
