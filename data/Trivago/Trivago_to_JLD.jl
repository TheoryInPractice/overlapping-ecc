using MAT
using JLD
include("../../src/helpers.jl")

mat = matread("Trivago_Clickout_EdgeLabels.mat")
EdgeColors = mat["EdgeLabels"]
H = mat["H"]
m,n = size(H)
M = length(EdgeColors)
EdgeList = incidence2elist(H)

save("../JLD_Files/Trivago.jld", "Edgelist", EdgeList, "EdgeColors", EdgeColors, "n", n)