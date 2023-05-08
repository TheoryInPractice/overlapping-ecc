using JLD
using MAT
using Statistics
include("../src/EdgeCatClusAlgs.jl")

datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]

numdata = length(datasets)
dataset_stats = zeros(numdata, 9)

for i = 1:length(datasets)
    dataset = datasets[i]
    println("Dataset Stats: "*dataset*"...")

    data = load("../data/JLD_Files/"*dataset*".jld")
    EdgeColors = data["EdgeColors"]
    EdgeList = data["EdgeList"]
    n = data["n"]
    M = length(EdgeColors)
    r = MaxHyperedgeSize(EdgeList)
    k = maximum(EdgeColors)

    #min, max, median, mean edge size
    EdgeSizes = zeros(M)
    for j = 1:M
        EdgeSizes = length(EdgeList[j])
    end
    r_median = median(EdgeSizes)
    r_mean = round(mean(EdgeSizes), digits=2)

    #min, max, median, mean chromatic degree
    ColorDegrees = get_color_degree(EdgeList, EdgeColors, n)
    chromatic_degrees = zeros(n)
    for c = 1:k
        for v = 1:n
            if ColorDegrees[c, v] > 0
                chromatic_degrees[v] += 1
            end
        end        
    end

    max_chrom_deg = maximum(chromatic_degrees)
    median_chrom_deg = median(chromatic_degrees)
    mean_chrom_deg  = round(mean(chromatic_degrees), digits=2)

    println("Stats for dataset: "*dataset*"...")
    println("n: $n")
    println("M: $M")
    println("k: $k")
    println("r: $r")
    println("med r: $r_median")
    println("mean r: $r_mean")
    println("max cd: $max_chrom_deg")
    println("med cd: $median_chrom_deg")
    println("mean cd: $mean_chrom_deg")
    println("")

end