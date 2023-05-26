using JLD
using MAT
include("../src/GoECCAlgs.jl")
include("../src/EdgeCatClusAlgs.jl")

## Run all GoECC Algorithms
# This script aggregates all Global ECC algorithm experiments, across all datasets and budgets.
# In practice, different datasets and budgets were tested separately.
# This is especially important if memory is a concern.

datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]
budgets = [0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4]

for i = 1:length(datasets)
    dataset = datasets[i]
    println("Processing dataset: "*dataset*"...")

    data = load("../data/JLD_Files/"*dataset*".jld")
    EdgeColors = data["EdgeColors"]
    EdgeList = data["EdgeList"]
    n = data["n"]
    M = length(EdgeColors)
    msize = MaxHyperedgeSize(EdgeList)
    k = maximum(EdgeColors)
    println("Hypergraph: "*dataset*" has $M edges $n nodes, and $msize maximum order, $k colors")

    for j = 1:length(budgets)
        budget = Int64(floor(n*budgets[j]))
        println("...with global budget: $budget")

        # Solve the LP relaxation
        start = time()
        LPval, X, Z, runtime = GoECCLP(EdgeList, EdgeColors, n, budget, false, 0)
        
        # Round the clustering
        bicrit_c, round_score, round_ratio, budget_score, budget_ratio = GoECCRound(EdgeList, EdgeColors, X, Z, LPval, budget)
        satisfaction = 1 - round_score/M
        run = round(time() - start, digits=2)

        # Run the greedy approximation
        start = time()
        greedy_c = GreedyGlobal(EdgeList, EdgeColors, n, k, budget)
        greedy_runtime = time()-start
        greedy_mistakes = OverlappingEdgeCatClusObj(EdgeList, EdgeColors, greedy_c)
        greedy_ratio = greedy_mistakes / LPval
        greedy_satisfaction = 1 - greedy_mistakes/M

        bstring = string(budgets[j])
        matwrite("Output/GoECC/"*dataset*"_b"*bstring*"_results.mat", Dict("LPval"=>LPval,
        "x"=>X, "Z"=>Z, "runtime"=>run, "c"=>bicrit_c, "mistakes"=>round_score,
        "ratio"=>round_ratio, "satisfaction"=> satisfaction, "n"=>n,
        "budget_score"=>budget_score, "budget_ratio"=>budget_ratio,
        "greedy_c"=>greedy_c, "greedy_runtime"=>greedy_runtime,
        "greedy_mistakes"=>greedy_mistakes,"greedy_ratio"=>greedy_ratio,"greedy_satisfaction"=>greedy_satisfaction,
        ))
    end
end