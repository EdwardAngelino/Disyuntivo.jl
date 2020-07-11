module Disyuntivo

# Write your package code here.
using JuMP, CPLEX
using CSV, DataFrames, DelimitedFiles, SparseArrays

struct ol                   #para manejar las conexiones entre lineas sparsivos
    be :: Int
    br :: Int
end

struct ob
    bi ::Int
end
export ol, ob
export escriberesultados
export leedatostxt
include("frames.jl")
include("leearchivo.jl")
include("modelo.jl")
include("resultados.jl")
end
