using MAT

println("")
datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]
colors = [1, 2, 3, 4, 5, 8, 16, 32]

println("B+1 Algorithm Results:")
for i = 1:length(datasets)
    dataset = datasets[i]
    println("DATASET: "*dataset*"")
    for j = 1:length(colors)
        b = colors[j]
        mat = matread("/scratch/tmp/crane/overlapping-ecc/LoECC/"*dataset*"_b"*string(b)*"_results.mat")
        lpval = round(mat["LPval"], digits=2)
        bp1_mistakes = mat["bplusone_mistakes"]
        bp1_ratio = round(mat["bplusone_ratio"], digits=2)
        bp1_sat = round(mat["bplusone_satisfaction"], digits=2)
        bp1_runtime = mat["canonical_runtime"]
        println("budget = $b    lp = $lpval    bp1 apx = $bp1_ratio    bp1 mistakes = $bp1_mistakes    bp1 sat% = $bp1_sat    bp1 runtime = $bp1_runtime")
    end
end

println("")
println("Bi-criteria Results:")
for i = 1:length(datasets)
    dataset = datasets[i]
    println("DATASET: "*dataset*"")
    for j = 1:length(colors)
        b = colors[j]
        mat = matread("/scratch/tmp/crane/overlapping-ecc/LoECC/"*dataset*"_b"*string(b)*"_results.mat")
        lpval = round(mat["bicrit_LPval"], digits=2)
        bicrit_mistakes = mat["bicrit_mistakes"]
        bicrit_ratio = round(mat["bicrit_ratio"], digits=10)
        bicrit_sat = round(mat["bicrit_satisfaction"], digits=2)
        bicrit_max_colors = mat["bicrit_max_colors"]
        bicrit_budget_ratio = round(mat["bicrit_budget_ratio"], digits=10)
        bicrit_runtime = mat["bicrit_runtime"]
        println("budget = $b    lp = $lpval    bicrit apx = $bicrit_ratio    bicrit mistakes = $bicrit_mistakes    bicrit sat% = $bicrit_sat    max colors: $bicrit_max_colors    budget apx: $bicrit_budget_ratio    bicrit runtime = $bicrit_runtime")
    end
end

println("")
println("Greedy Results:")
for i = 1:length(datasets)
    dataset = datasets[i]
    println("DATASET: "*dataset*"")
    for j = 1:length(colors)
        b = colors[j]
        mat = matread("/scratch/tmp/crane/overlapping-ecc/LoECC/"*dataset*"_b"*string(b)*"_results.mat")
        
        greedy_runtime = round(mat["greedy_runtime"], digits=2)
        greedy_mistakes = mat["greedy_mistakes"]
        greedy_ratio = round(mat["greedy_ratio"],digits=4)
        greedy_satisfaction = round(mat["greedy_satisfaction"],digits=2)
        println("budget = $b    greedy apx = $greedy_ratio    greedy mistakes = $greedy_mistakes    greedy sat% = $greedy_satisfaction   greedy runtime = $greedy_runtime" )
    end
end
