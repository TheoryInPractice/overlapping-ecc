using JLD
using MAT
include("../src/LoECCAlgs.jl")
include("../src/EdgeCatClusAlgs.jl")

## Run all LoECC Algorithms
# This script aggregates all Local ECC algorithm experiments, across all datasets and budgets.
# In practice, different datasets and budgets were tested separately.
# This is especially important if memory is a concern.

datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]
datasets = ["Trivago"]
colors = [3, 4, 5, 8, 16, 32]

for i = 1:length(datasets)
    dataset = datasets[i]
    println("Processing dataset: "*dataset*"...")

    data = load("../data/JLD_Files/"*dataset*".jld")
    EdgeColors = data["EdgeColors"]
    EdgeList = data["EdgeList"]
    n = data["n"]
    M = length(EdgeColors)
    msize = MaxHyperedgeSize(EdgeList)
    k = round.(Int64,maximum(EdgeColors))
    println("Hypergraph: "*dataset*" has $M edges $n nodes, and $msize maximum order, $k colors")

    for j = 1:length(colors)        
        b = colors[j]
        println("...with local budget: $b")
    
        # Solve the LO-ECC LP Relaxation
        start = time()
        bicrit_LPval, bicrit_X, runtime = LoECCCanonicalLP(EdgeList, EdgeColors, n, b, false, 0)
        
        # Round the clustering for a bi-criteria approximation
        bicrit_c, round_score2, round_ratio2, budget_score, budget_ratio = LoECCBicriteriaRound(EdgeList, EdgeColors, bicrit_X, bicrit_LPval, b, 0.5)
        bicrit_satisfaction = 1 - round_score2/M
        run2 = round(time() - start, digits=2)

        # Run the greedy approximation
        start = time()
        greedy_c = GreedyLocal(EdgeList, EdgeColors, n, k, b)
        greedy_runtime = time()-start
        greedy_mistakes = OverlappingEdgeCatClusObj(EdgeList, EdgeColors, greedy_c)
        greedy_ratio = greedy_mistakes / bicrit_LPval
        greedy_satisfaction = 1 - greedy_mistakes/M

        bstring = string(b)
        matwrite("Output/LoECC/"*dataset*"_b"*bstring*"_results.mat", Dict(
        "bicrit_LPval"=> bicrit_LPval, "bicrit_X"=>bicrit_X, "bicrit_runtime"=>run2,
        "bicrit_c"=>bicrit_c, "bicrit_mistakes"=>round_score2, "bicrit_ratio"=>round_ratio2,
        "bicrit_max_colors"=>budget_score, "bicrit_budget_ratio"=>budget_ratio,
        "bicrit_satisfaction"=>bicrit_satisfaction, "greedy_c"=>greedy_c, "greedy_runtime"=>greedy_runtime,
        "greedy_mistakes"=>greedy_mistakes,"greedy_ratio"=>greedy_ratio,"greedy_satisfaction"=>greedy_satisfaction))
    end
end
