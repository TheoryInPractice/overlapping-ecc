using JLD
using MAT
using Statistics
include("../src/EdgeCatClusAlgs.jl")

datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]

numdata = length(datasets)

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
        EdgeSizes[j] = length(EdgeList[j])
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

    #favorite colors and total degrees
    favorite_colors = zeros(n)
    degrees = zeros(n)
    for v = 1:n
        favorite_color = 1
        degree = 0
        for c = 1:k
            degree += ColorDegrees[c, v]
            if ColorDegrees[c, v] > ColorDegrees[favorite_color, v]
                favorite_color = c
            end
        end
        favorite_colors[v] = favorite_color
        degrees[v] = degree
    end

    #degree and non dominant degree
    non_dominant_degrees = zeros(n)
    for v = 1:n
        non_dominant_degrees[v] = degrees[v] - ColorDegrees[Int64(favorite_colors[v]), v]
    end
    max_non_dominant_degree = maximum(non_dominant_degrees)
    mean_non_dominant_degree = mean(non_dominant_degrees)
    median_non_dominant_degree = median(non_dominant_degrees)

    max_degree = maximum(degrees)
    mean_degree = mean(degrees)
    median_degree = median(degrees)
            
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
    println("max deg: $max_degree")
    println("median deg: $median_degree")
    println("mean deg: $mean_degree")
    println("max nd deg: $max_non_dominant_degree")
    println("median nd deg: $median_non_dominant_degree")
    println("mean nd deg: $mean_non_dominant_degree")
    println("")

    matwrite("Output/dataset_stats/dataset_"*dataset*"_stats.mat", Dict(
        "n"=>n, "M"=>M, "k"=>k, "r"=>r, "r_mean"=>r_mean,"r_median"=>r_median,
        "max_chrom_deg"=>max_chrom_deg,"mean_chrom_deg"=>mean_chrom_deg,
        "median_chrom_deg"=>median_chrom_deg,
        "chromatic_degrees"=>chromatic_degrees,
        "favorite_colors"=>favorite_colors,
        "degrees"=>degrees,
        "non_dominant_degrees"=>non_dominant_degrees, 
    ))
end