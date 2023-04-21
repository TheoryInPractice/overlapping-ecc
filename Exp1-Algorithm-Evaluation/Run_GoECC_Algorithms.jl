using JLD
using MAT
include("../src/GoECCAlgs.jl")
include("../src/EdgeCatClusAlgs.jl")

datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips"]
# datasets = ["Walmart-Trips"]
# datasets = ["Brain", "MAG-10", "Cooking", "DAWN"]
budgets = [0, 0.5, 1, 1.5, 2]

numdata = length(datasets)
dataset_stats = zeros(numdata, 4)

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
        run = round(time() - start, digits=2)

        # Round the clustering
        bicrit_c, round_score, round_ratio, budget_score, budget_ratio = GoECCRound(EdgeList, EdgeColors, X, Z, LPval, budget)
        satisfaction = 1 - round_score/M

        bstring = string(budgets[j])

        matwrite("Output/GoECC/"*dataset*"_b"*bstring*"_results.mat", Dict("LPval"=>LPval,
        "x"=>X, "Z"=>Z, "runtime"=>run, "c"=>bicrit_c, "mistakes"=>round_score,
        "ratio"=>round_ratio, "satisfaction"=> satisfaction, "n"=>n,
        "budget_score"=>budget_score, "budget_ratio"=>budget_ratio))
    end
end