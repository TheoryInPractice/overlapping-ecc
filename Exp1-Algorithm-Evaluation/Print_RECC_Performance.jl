using MAT

println("")
datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]
budgets = [0, .01, .05, .1, .15, .2, .25]

println("R-ECC Bicriteria Results (1/3, 1/2)")
for i = 1:length(datasets)
    dataset = datasets[i]
    println("DATASET: "*dataset*"")
    for j = 1:length(budgets)
        b = budgets[j]
        mat = matread("Output/RECC/"*dataset*"_b"*string(b)*"_results.mat")
        lpval = round(mat["LPval"], digits = 2)
        mistakes = mat["mistakes"]
        ratio = round(mat["ratio"], digits=4)
        satisfaction = round(mat["satisfaction"], digits=2)
        budget_used = mat["budget_score"]
        budget_ratio = round(mat["budget_ratio"], digits=4)
        budget = Int64(floor(b*mat["n"]))
        runtime = round(mat["runtime"], digits=2)
        println("budget = $budget = $b * n    lp = $lpval    apx = $ratio    mistakes = $mistakes    satisfaction = $satisfaction    deleted nodes = $budget_used    budget ratio = $budget_ratio    runtime = $runtime")
    end
end

println("")
println("Greedy Results:")
for i = 1:length(datasets)
    dataset = datasets[i]
    println("DATASET: "*dataset*"")
    for j = 1:length(budgets)
        b = budgets[j]
        mat = matread("Output/RECC/"*dataset*"_b"*string(b)*"_results.mat")
        greedy_runtime = round(mat["greedy_runtime"], digits=2)
        greedy_mistakes = mat["greedy_mistakes"]
        greedy_ratio = round(mat["greedy_ratio"],digits=4)
        greedy_satisfaction = round(mat["greedy_satisfaction"],digits=10)
        println("budget = $b    greedy apx = $greedy_ratio    greedy mistakes = $greedy_mistakes    greedy sat% = $greedy_satisfaction   greedy runtime = $greedy_runtime" )
    end
end
