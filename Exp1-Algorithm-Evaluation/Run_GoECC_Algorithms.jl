using JLD
using MAT
include("../src/GoECCAlgs.jl")
include("../src/EdgeCatClusAlgs.jl")
include("../src/helpers.jl")

datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]
# datasets = ["Walmart-Trips", "Trivago"]
# datasets = ["Brain", "MAG-10", "Cooking", "DAWN"]
# datasets = ["Trivago"]
budgets = [0, 0.5, 1, 1.5, 2, 3, 3.5, 4]
# budgets = [3, 3.5, 4]
# budgets = [2.5]
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

        # Run the greedy approximation
        start = time()
        greedy_c = GreedyGlobal(EdgeList, EdgeColors, n, k, budget)
        greedy_runtime = time()-start
        greedy_mistakes = OverlappingEdgeCatClusObj(EdgeList, EdgeColors, greedy_c)
        greedy_ratio = greedy_mistakes / LPval
        greedy_satisfaction = 1 - greedy_mistakes/M

        bstring = string(budgets[j])

        # collect stats on useless assignments and unused nodes
        bicrit_useless_count, bicrit_useless_per_node, bicrit_useless = get_useless_assignments(EdgeList, EdgeColors, bicrit_c)
        greedy_useless_count, greedy_useless_per_node, greedy_useless = get_useless_assignments(EdgeList, EdgeColors, greedy_c)

        bicrit_unused_count, bicrit_unused_list, bicrit_sat_per_node = get_unused_nodes(EdgeList, EdgeColors, bicrit_c)
        greedy_unused_count, greedy_unused_list, greedy_sat_per_node = get_unused_nodes(EdgeList, EdgeColors, greedy_c)
        LPminusG, GminusLP, LPsymdiffG = compare_clusterings(EdgeList, EdgeColors, bicrit_c, greedy_c)
        LPminusG_size = length(LPminusG)
        GminusLP_size = length(GminusLP)
        symdiff_size = length(LPsymdiffG)
        # GminusLP_ratio = GminusLP_size / symdiff_size

        matwrite("/scratch/tmp/crane/overlapping-ecc/GoECC/"*dataset*"_b"*bstring*"_results.mat", Dict("LPval"=>LPval,
        "x"=>X, "Z"=>Z, "runtime"=>run, "c"=>bicrit_c, "mistakes"=>round_score,
        "ratio"=>round_ratio, "satisfaction"=> satisfaction, "n"=>n,
        "budget_score"=>budget_score, "budget_ratio"=>budget_ratio,
        "greedy_c"=>greedy_c, "greedy_runtime"=>greedy_runtime,
        "greedy_mistakes"=>greedy_mistakes,"greedy_ratio"=>greedy_ratio,"greedy_satisfaction"=>greedy_satisfaction,
        "bicrit_useless_count"=>bicrit_useless_count, "greedy_useless_count"=>greedy_useless_count,
        "LPminusG"=>LPminusG_size, "GminusLP"=>GminusLP_size, "symdiff_size"=>symdiff_size,
        ))
    end
end