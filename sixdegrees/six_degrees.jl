using Pkg
pkg"activate ."
include("Wikipedia.jl")
using .Wikipedia

fetchrandom() |> articlelinks |> display
