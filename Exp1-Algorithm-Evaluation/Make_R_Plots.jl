using MAT
using Plots
using Measures

# datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips"]
datasets = ["Brain", "MAG-10", "Cooking", "DAWN"]
deletion_budgets = [0, .01, .05, .1, .15, .2, .25]

mistakes = []
lp_scores = []
satisfactions = []
alphas = []
betas = []
mistakes_above_lp = []

for i = 1:length(datasets)
    dataset = datasets[i]
    push!(mistakes, [])
    push!(lp_scores, [])
    push!(satisfactions, [])
    push!(alphas, [])
    push!(betas, [])
    push!(mistakes_above_lp, [])
    for j = 1:length(deletion_budgets)
        bstring = string(deletion_budgets[j])
        data = matread("/scratch/tmp/crane/overlapping-ecc/RECC/"*dataset*"_b"*bstring*"_results.mat")
        push!(mistakes[i], data["mistakes"])
        push!(lp_scores[i], data["LPval"])
        push!(satisfactions[i], data["satisfaction"])
        push!(alphas[i], data["ratio"])
        push!(betas[i], data["budget_ratio"])
        push!(mistakes_above_lp[i], data["mistakes"] - data["LPval"])
    end
end

xs = deletion_budgets
x_label = "b = global budget (% of n)"
y_label = "mistakes"
l_place = :topright
s1 = 300
s2 = 250
ms = 5
lw = 2
title = "R-ECC Mistakes"
plot(xs, mistakes[1], title = title,
    labels = "Brain",
    grid = false, size = (s1, s2),
    xlabel = x_label, xlim = [0,.25], ylabel = y_label, legend = l_place,
    linewidth = lw, markerstrokewidth = 0, markershape = :circle,
    color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
)
plot!(xs, mistakes[2], linewidth=lw, labels="MAG-10",markershape = :circle,
markerstrokewidth = 0, color = :black, markersize=ms )
plot!(xs, mistakes[3], linewidth=lw, labels="Cooking",markershape = :circle,
markerstrokewidth=0, color =:red, markersize=ms)
plot!(xs, mistakes[4], linewidth=lw, labels="DAWN",markershape = :circle,
markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, mistakes[5], linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
savefig("Plots/RECC/mistakes.pdf")

xs = deletion_budgets
x_label = "b = global budget (% of n)"
y_label = "Edge Satisfaction %"
l_place = :bottomright
s1 = 300
s2 = 250
ms = 5
lw = 2
title = "R-ECC Edge Satisfaction"
plot(xs, satisfactions[1].*100, title = title,
    labels = "Brain",
    grid = false, size = (s1, s2),
    xlabel = x_label, xlim = [0,.25], ylabel = y_label, legend = l_place,
    linewidth = lw, markerstrokewidth = 0, markershape = :circle,
    color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
)
plot!(xs, satisfactions[2].*100, linewidth=lw, labels="MAG-10",markershape = :circle,
markerstrokewidth = 0, color = :black, markersize=ms )
plot!(xs, satisfactions[3].*100, linewidth=lw, labels="Cooking",markershape = :circle,
markerstrokewidth=0, color =:red, markersize=ms)
plot!(xs, satisfactions[4].*100, linewidth=lw, labels="DAWN",markershape = :circle,
markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, satisfactions[5].*100, linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
savefig("Plots/RECC/satisfactions.pdf")

xs = deletion_budgets
x_label = "b = global budget (% of n)"
y_label = "mistakes above LP"
l_place = :topright
s1 = 300
s2 = 250
ms = 5
lw = 2
title = "R-ECC Mistakes Above LP"
plot(xs, mistakes_above_lp[1], title = title,
    labels = "Brain",
    grid = false, size = (s1, s2),
    xlabel = x_label, xlim = [0,.25], ylabel = y_label, legend = l_place,
    linewidth = lw, markerstrokewidth = 0, markershape = :circle,
    color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
)
plot!(xs, mistakes_above_lp[2], linewidth=lw, labels="MAG-10",markershape = :circle,
markerstrokewidth = 0, color = :black, markersize=ms )
plot!(xs, mistakes_above_lp[3], linewidth=lw, labels="Cooking",markershape = :circle,
markerstrokewidth=0, color =:red, markersize=ms)
plot!(xs, mistakes_above_lp[4], linewidth=lw, labels="DAWN",markershape = :circle,
markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, mistakes_above_lp[5], linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
savefig("Plots/RECC/mistakes_above_lp.pdf")

xs = deletion_budgets
x_label = "b = global budget (% of n)"
y_label = "Approximation Factors"
l_place = :topright
s1 = 300
s2 = 250
ms = 5
lw = 2
title = "R-ECC Objective Approximation Factors"
plot(xs, alphas[1], title = title,
    labels = "Brain",
    grid = false, size = (s1, s2),
    xlabel = x_label, xlim = [0,.25], ylabel = y_label, legend = l_place,
    linewidth = lw, markerstrokewidth = 0, markershape = :circle,
    color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
)
plot!(xs, alphas[2], linewidth=lw, labels="MAG-10",markershape = :circle,
markerstrokewidth = 0, color = :black, markersize=ms )
plot!(xs, alphas[3], linewidth=lw, labels="Cooking",markershape = :circle,
markerstrokewidth=0, color =:red, markersize=ms)
plot!(xs, alphas[4], linewidth=lw, labels="DAWN",markershape = :circle,
markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, alphas[5], linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
savefig("Plots/RECC/alphas.pdf")

xs = deletion_budgets
x_label = "b = global budget (% of n)"
y_label = "Node deletions (% of budget)"
l_place = :bottom
s1 = 300
s2 = 250
ms = 5
lw = 2
title = "R-ECC Deletion Budget Usage"
plot(xs, betas[1].*100, title = title,
    labels = "Brain",
    grid = false, size = (s1, s2),
    xlabel = x_label, xlim = [0,.25], ylabel = y_label, legend = l_place,
    linewidth = lw, markerstrokewidth = 0, markershape = :circle,
    color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
)
plot!(xs, betas[2].*100, linewidth=lw, labels="MAG-10",markershape = :circle,
markerstrokewidth = 0, color = :black, markersize=ms )
plot!(xs, betas[3].*100, linewidth=lw, labels="Cooking",markershape = :circle,
markerstrokewidth=0, color =:red, markersize=ms)
plot!(xs, betas[4].*100, linewidth=lw, labels="DAWN",markershape = :circle,
markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, betas[5].*100, linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
savefig("Plots/RECC/betas.pdf")


