using MAT
using JLD
include("../src/EdgeCatClusAlgs.jl")
include("../src/helpers.jl")

# GoECC_Greedy_Compare()

function LoECC_Greedy_Compare()

    datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]
    # datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips"]

    # datasets = ["Brain"]
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
            mat = matread("/scratch/tmp/crane/overlapping-ecc/LoECC/"*dataset*"_b"*string(b)*"_results.mat")
            lpval = round(mat["bicrit_LPval"], digits=2)
            bicrit_mistakes = mat["bicrit_mistakes"]
            bicrit_c = convertToArray(mat["bicrit_c"], n, k)
            greedy_c = convertToArray(mat["greedy_c"], n, k)

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

end

LoECC_Greedy_Compare()