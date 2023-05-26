using JLD
using MAT
include("../src/RECCAlgs.jl")
include("../src/EdgeCatClusAlgs.jl")

## Run all RECC Algorithms
# This script aggregates all Robust ECC algorithm experiments, across all datasets and budgets.
# In practice, different datasets and budgets were tested separately.
# This is especially important if memory is a concern.

datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]
deletion_budgets = [0, .01, .05, .1, .15, .2, .25]

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

    for j = 1:length(deletion_budgets)
        budget = Int64(floor(n*deletion_budgets[j]))
        println("...with budget: $budget")

        # Solve the LP relaxation
        start = time()
        LPval, X, Z, runtime = RECCLP(EdgeList, EdgeColors, n, budget, false, 0)

        # Round the clustering
        bicrit_c, round_score, round_ratio, budget_score, budget_ratio = RECCRound(EdgeList, EdgeColors, X, Z, LPval, budget)
        satisfaction = 1 - round_score/M
        run = round(time() - start, digits=2)

        # Run the greedy approximation
        start = time()
        greedy_c = GreedyRobust(EdgeList, EdgeColors, n, k, budget)
        greedy_runtime = time()-start
        greedy_mistakes = OverlappingEdgeCatClusObj(EdgeList, EdgeColors, greedy_c)
        greedy_ratio = greedy_mistakes / LPval
        greedy_satisfaction = 1 - greedy_mistakes/M

        bstring = string(deletion_budgets[j])
        matwrite("Output/RECC/"*dataset*"_b"*bstring*"_results.mat", Dict("LPval"=>LPval,
        "X"=>X, "Z"=>Z, "runtime"=>run, "c"=>bicrit_c, "mistakes"=>round_score,
        "ratio"=>round_ratio, "satisfaction"=> satisfaction, "n"=>n,
        "budget_score"=>budget_score, "budget_ratio"=>budget_ratio,
        "greedy_c"=>greedy_c, "greedy_runtime"=>greedy_runtime,
        "greedy_mistakes"=>greedy_mistakes,"greedy_ratio"=>greedy_ratio,"greedy_satisfaction"=>greedy_satisfaction))
    end
end