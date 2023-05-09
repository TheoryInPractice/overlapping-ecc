using JLD
using MAT
using Statistics
include("../src/EdgeCatClusAlgs.jl")

datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]

numdata = length(datasets)
ns = []
Ms = []
ks = []
rs = []
r_means = []
r_medians = []
chrom_deg_maxs = []
chrom_deg_means = []
chrom_deg_medians = []

brain_cds = []
mag10_cds = []
cooking_cds = []
dawn_cds = []
walmart_cds = []
trivago_cds = []
chrom_deg_lists = [brain_cds, mag10_cds, cooking_cds, dawn_cds, walmart_cds, trivago_cds]

for i = 1:length(datasets)
    push!(chrom_deg_lists, [])
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
    push!(ns, n)
    push!(Ms, M)
    push!(ks, k)
    push!(rs, r)
    push!(r_means, r_mean)
    push!(r_medians, r_median)
    push!(chrom_deg_maxs, max_chrom_deg)
    push!(chrom_deg_means, mean_chrom_deg)
    push!(chrom_deg_medians, median_chrom_deg)
    for val in chromatic_degrees
        push!(chrom_deg_lists[i],val)
    end
end

matwrite("dataset_stats.mat", Dict("ns"=>ns,
"Ms"=>Ms,"ks"=>ks,"rs"=>rs,"r_means"=>r_means,"r_medians"=>r_medians,
"chrom_deg_maxs"=>chrom_deg_maxs,"chrom_deg_means"=>chrom_deg_means,
"chrom_deg_medians"=>chrom_deg_medians,
"brain_chrom_degs"=>chrom_deg_lists[1],
"mag10_chrom_degs"=>chrom_deg_lists[2],
"cooking_chrom_degs"=>chrom_deg_lists[3],
"dawn_chrom_degs"=>chrom_deg_lists[4],
"walmart_chrom_degs"=>chrom_deg_lists[5],
"trivago_chrom_degs"=>chrom_deg_lists[6],
))