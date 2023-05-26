using MAT
using JLD
include("../src/EdgeCatClusAlgs.jl")
include("../src/helpers.jl")
include("../src/GoECCAlgs.jl")
include("../src/LoECCAlgs.jl")

function LoECC_Greedy_Compare()

    println("LO-ECC")

    datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]
    colors = [1, 2, 3, 4, 5, 8, 16, 32]
    for i = 1:length(datasets)
        dataset = datasets[i]
        println("DATASET: "*dataset*"")
        data = load("../data/JLD_Files/"*dataset*".jld")
        EdgeColors = data["EdgeColors"]
        EdgeList = data["EdgeList"]
        n = data["n"]
        M = length(EdgeColors)
        msize = MaxHyperedgeSize(EdgeList)
        k = round.(Int64,maximum(EdgeColors))
        for j = 1:length(colors)
            b = colors[j]
            mat = matread("Output/LoECC/"*dataset*"_b"*string(b)*"_results.mat")
            lpval = round(mat["bicrit_LPval"], digits=2)
            bicrit_mistakes = mat["bicrit_mistakes"]

            # recompute the greedy clustering (only takes seconds)
            greedy_c = GreedyLocal(EdgeList, EdgeColors, n, k, b)

            # use the optimal LP variables to recompute the rounded clustering
            bicrit_LPval = mat["bicrit_LPval"]
            bicrit_X = mat["bicrit_X"]
            bicrit_c, round_score, round_ratio, budget_score, budget_ratio = LoECCBicriteriaRound(EdgeList, EdgeColors, bicrit_X, bicrit_LPval, b, 0.5)

            bicrit_useless_count, bicrit_useless_per_node, bicrit_useless = get_useless_assignments(EdgeList, EdgeColors, bicrit_c)
            greedy_useless_count, greedy_useless_per_node, greedy_useless = get_useless_assignments(EdgeList, EdgeColors, greedy_c)

            bicrit_unused_count, bicrit_unused_list, bicrit_sat_per_node = get_unused_nodes(EdgeList, EdgeColors, bicrit_c)
            greedy_unused_count, greedy_unused_list, greedy_sat_per_node = get_unused_nodes(EdgeList, EdgeColors, greedy_c)
            
            LPminusG, GminusLP, LPsymdiffG = compare_clusterings(EdgeList, EdgeColors, bicrit_c, greedy_c)
            LPminusG_size = length(LPminusG)
            GminusLP_size = length(GminusLP)
            symdiff_size = length(LPsymdiffG)
            GminusLP_ratio = GminusLP_size / symdiff_size

            greedy_extra_unused = greedy_unused_count - bicrit_unused_count
            greedy_extra_useless = greedy_useless_count - bicrit_useless_count
            
            println("budget = $b...")
            println("   bicrit_useless: $bicrit_useless_count, greedy_useless: $greedy_useless_count, greedy_extra_useless: $greedy_extra_useless")
            println("   bicrit_unused: $bicrit_unused_count, greedy_unused_count: $greedy_unused_count, greedy_extra_unused: $greedy_extra_unused")
            println("   bicrit - greedy: $LPminusG_size, greedy - bicrit: $GminusLP_size, symdiff: $symdiff_size  greedy_ratio: $GminusLP_ratio")

            bstring = string(b)
            matwrite("Output/stats/loecc"*dataset*"_b"*bstring*"_greedycompare.mat", Dict(
                "bicrit_useless"=>bicrit_useless_count,"bicrit_unused"=>bicrit_unused_count,
                "greedy_useless"=>greedy_useless_count,"greedy_unused"=>greedy_unused_count,
                "LPminusG"=>LPminusG_size,"GminusLP"=>GminusLP_size,"symdiff"=>symdiff_size,
            ))            
        end
    end
end

function GoECC_Greedy_Compare()

    println("GO-ECC")

    datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]
    budgets = [0.0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4]
    for i = 1:length(datasets)
        dataset = datasets[i]
        println("DATASET: "*dataset*"")
        data = load("../data/JLD_Files/"*dataset*".jld")
        EdgeColors = data["EdgeColors"]
        EdgeList = data["EdgeList"]
        n = data["n"]
        M = length(EdgeColors)
        msize = MaxHyperedgeSize(EdgeList)
        k = round.(Int64,maximum(EdgeColors))

        for j = 1:length(budgets)
            budget = Int64(floor(n*budgets[j]))
            bstring = string(budgets[j])
            mat = matread("Output/GoECC/"*dataset*"_b"*bstring*"_results.mat")

            # recompute the greedy clustering (only takes seconds)
            greedy_c = GreedyGlobal(EdgeList, EdgeColors, n, k, budget)

            # we only have the LP variables, so recompute the rounded clustering
            X = mat["x"]
            Z = mat["Z"]
            LPval = mat["LPval"]
            bicrit_c, round_score, round_ratio, budget_score, budget_ratio = GoECCRound(EdgeList, EdgeColors, X, Z, LPval, budget)

            bicrit_useless_count, bicrit_useless_per_node, bicrit_useless = get_useless_assignments(EdgeList, EdgeColors, bicrit_c)
            greedy_useless_count, greedy_useless_per_node, greedy_useless = get_useless_assignments(EdgeList, EdgeColors, greedy_c)

            bicrit_unused_count, bicrit_unused_list, bicrit_sat_per_node = get_unused_nodes(EdgeList, EdgeColors, bicrit_c)
            greedy_unused_count, greedy_unused_list, greedy_sat_per_node = get_unused_nodes(EdgeList, EdgeColors, greedy_c)
            
            LPminusG, GminusLP, LPsymdiffG = compare_clusterings(EdgeList, EdgeColors, bicrit_c, greedy_c)
            LPminusG_size = length(LPminusG)
            GminusLP_size = length(GminusLP)
            symdiff_size = length(LPsymdiffG)
            GminusLP_ratio = GminusLP_size / symdiff_size

            greedy_extra_unused = greedy_unused_count - bicrit_unused_count
            greedy_extra_useless = greedy_useless_count - bicrit_useless_count

            println("budget = $bstring...")
            println("   bicrit_useless: $bicrit_useless_count, greedy_useless: $greedy_useless_count, greedy_extra_useless: $greedy_extra_useless")
            println("   bicrit_unused: $bicrit_unused_count, greedy_unused_count: $greedy_unused_count, greedy_extra_unused: $greedy_extra_unused")
            println("   bicrit - greedy: $LPminusG_size, greedy - bicrit: $GminusLP_size, symdiff: $symdiff_size  greedy_ratio: $GminusLP_ratio")

            matwrite("Output/stats/goecc"*dataset*"_b"*bstring*"_greedycompare.mat", Dict(
                "bicrit_useless"=>bicrit_useless_count,"bicrit_unused"=>bicrit_unused_count,
                "greedy_useless"=>greedy_useless_count,"greedy_unused"=>greedy_unused_count,
                "LPminusG"=>LPminusG_size,"GminusLP"=>GminusLP_size,"symdiff"=>symdiff_size,
            ))
        end
    end
end

LoECC_Greedy_Compare()
GoECC_Greedy_Compare()