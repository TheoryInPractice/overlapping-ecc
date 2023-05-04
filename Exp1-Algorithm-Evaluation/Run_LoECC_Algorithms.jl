using JLD
using MAT
include("../src/LoECCAlgs.jl")
include("../src/EdgeCatClusAlgs.jl")

datasets = ["Brain"]
# datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips"]
# datasets = ["Walmart-Trips"]
# datasets = ["Brain", "MAG-10", "Cooking", "DAWN"]
colors = [1, 2, 4, 8, 16, 32]

numdata = length(datasets)
dataset_stats = zeros(numdata, 4)
bplusone_stats = zeros(numdata, length(colors), 4)

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

    for j = 1:length(colors)        
        b = colors[j]
        println("...with local budget: $b")

        # Solve the canonical LO-ECC LP Relaxation
        start = time()
        LPval, X, runtime = LoECCCanonicalLP(EdgeList, EdgeColors, n, b, false, 0, )
        run = round(time() - start, digits=2)

        # Round the clustering
        c, round_score, round_ratio = LoECCBPlusOneRound(EdgeList, EdgeColors, X, LPval, b)
        round_satisfaction = 1 - round_score / M
        bplusone_stats[i, j, :] = [round_score, round_ratio, round_satisfaction, run]
    
        # Solve the second LO-ECC LP Relaxation
        start = time()
        bicrit_LPval, bicrit_X, runtime = LoECCBicriteriaLP(EdgeList, EdgeColors, n, b, false, 0)
        run2 = round(time() - start, digits=2)

        # Round the clustering for a bi-criteria approximation
        bicrit_c, round_score2, round_ratio2, budget_score, budget_ratio = LoECCBicriteriaRound(EdgeList, EdgeColors, bicrit_X, bicrit_LPval, b, 0.5)
        bicrit_satisfaction = 1 - round_score2/M

        # Run the greedy approximation
        start = time()
        greedy_c = GreedyLocal(EdgeList, EdgeColors, n, k, b)
        greedy_runtime = time()-start
        greedy_mistakes = OverlappingEdgeCatClusObj(EdgeList, EdgeColors, greedy_c)
        greedy_ratio = greedy_mistakes / bicrit_LPval
        greedy_satisfaction = 1 - greedy_mistakes/M

        bstring = string(b)
        matwrite("Output/LoECC/"*dataset*"_b"*bstring*"_results.mat", Dict("LPval"=>LPval,
        "X"=>X, "canonical_runtime"=>run, "bplusone_c"=>c, "bplusone_mistakes"=>round_score,
        "bplusone_ratio"=>round_ratio,"bplusone_satisfaction"=>round_satisfaction,
        "bicrit_LPval"=> bicrit_LPval, "bicrit_X"=>bicrit_X, "bicrit_runtime"=>run2,
        "bicrit_c"=>bicrit_c, "bicrit_mistakes"=>round_score2, "bicrit_ratio"=>round_ratio2,
        "bicrit_max_colors"=>budget_score, "bicrit_budget_ratio"=>budget_ratio,
        "bicrit_satisfaction"=>bicrit_satisfaction, "greedy_c"=>greedy_c, "greedy_runtime"=>greedy_runtime,
        "greedy_mistakes"=>greedy_mistakes,"greedy_ratio"=>greedy_ratio,"greedy_satisfaction"=>greedy_satisfaction))
    end
end
