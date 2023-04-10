using MAT

println("")
datasets = ["Brain", "MAG-10", "Cooking", "DAWN"]
budgets = [0, 0.5, 1, 1.5, 2]

println("GO-ECC Bicriteria Results (epsilon = 1/2)")
for i = 1:length(datasets)
    dataset = datasets[i]
    println("DATASET: "*dataset*"")
    for j = 1:length(budgets)
        b = budgets[j]
        mat = matread("Output/GoECC/"*dataset*"_b"*string(b)*"_results.mat")
        lpval = round(mat["LPval"], digits = 2)
        mistakes = mat["mistakes"]
        ratio = round(mat["ratio"], digits=2)
        satisfaction = round(mat["satisfaction"], digits=2)
        budget_used = mat["budget_score"]
        budget_ratio = mat["budget_ratio"]
        budget = Int64(floor(b*mat["n"]))

        println("budget = $budget = $b * n    lp = $lpval    apx = $ratio    mistakes = $mistakes    satisfaction = $satisfaction    extra colors = $budget_used    budget ratio = $budget_ratio")
    end
end