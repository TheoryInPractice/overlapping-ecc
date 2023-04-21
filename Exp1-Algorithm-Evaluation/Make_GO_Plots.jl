using MAT
using Plots
using Measures

datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips"]
budgets = [0, 0.5, 1, 1.5, 2]

bicrit_mistakes = []
bicrit_satisfactions = []
lp_mistakes = []
bicrit_extra_colors = []
bicrit_alpha = []
bicrit_beta = []

for i = 1:length(datasets)
    dataset = datasets[i]
    push!(bicrit_mistakes, [])
    push!(bicrit_satisfactions, [])
    push!(lp_mistakes, [])
    push!(bicrit_extra_colors, [])
    push!(bicrit_alpha, [])
    push!(bicrit_beta, [])
    for j = 1:length(budgets)
        bstring = string(budgets[j])
        data = matread("/scratch/tmp/crane/overlapping-ecc/GoECC/"*dataset*"_b"*bstring*"_results.mat")
        push!(bicrit_mistakes[i], data["mistakes"])
        push!(bicrit_satisfactions[i], data["satisfaction"])
        push!(lp_mistakes[i], data["LPval"])
        push!(bicrit_extra_colors[i], data["budget_score"])
        push!(bicrit_alpha[i], data["ratio"])
        push!(bicrit_beta[i], data["budget_ratio"])
    end
end

mistakes_above_lp = []
for i = 1:length(datasets)
    push!(mistakes_above_lp, [])
    for j = 1:length(budgets)
        push!(mistakes_above_lp[i], bicrit_mistakes[i][j] - lp_mistakes[i][j])
    end
end

xs = budgets
x_label = "b = global budget (% of n)"
y_label = "mistakes"
l_place = :topright
s1 = 300
s2 = 250
ms = 5
lw = 2
title = "GO-ECC Mistakes"
plot(xs, bicrit_mistakes[1], title = title,
    labels = "Brain",
    grid = false, size = (s1, s2),
    xlabel = x_label, xlim = [0,2], ylabel = y_label, legend = l_place,
    linewidth = lw, markerstrokewidth = 0, markershape = :circle,
    color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
)
plot!(xs, bicrit_mistakes[2], linewidth=lw, labels="MAG-10",markershape = :circle,
markerstrokewidth = 0, color = :black, markersize=ms )
plot!(xs, bicrit_mistakes[3], linewidth=lw, labels="Cooking",markershape = :circle,
markerstrokewidth=0, color =:red, markersize=ms)
plot!(xs, bicrit_mistakes[4], linewidth=lw, labels="DAWN",markershape = :circle,
markerstrokewidth=0,color =:yellow, markersize=ms)
plot!(xs, bicrit_mistakes[5], linewidth=lw, labels="Walmart",markershape = :circle,
markerstrokewidth=0,color =:green, markersize=ms)
savefig("Plots/GoECC/bicrit_mistakes.pdf")

title = "GO-ECC Edge Satisfaction"
l_place = :bottomright
y_label = "Edge Satisfaction %"
plot(xs, bicrit_satisfactions[1].*100, title = title,
    labels = "Brain",
    grid = false, size = (s1, s2),
    xlabel = x_label, xlim = [0,2], ylabel = y_label, legend = l_place,
    linewidth = lw, markerstrokewidth = 0, markershape = :circle,
    color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
)
plot!(xs, bicrit_satisfactions[2].*100, linewidth=lw, labels="MAG-10",markershape = :circle,
markerstrokewidth = 0, color = :black, markersize=ms )
plot!(xs, bicrit_satisfactions[3].*100, linewidth=lw, labels="Cooking",markershape = :circle,
markerstrokewidth=0, color =:red, markersize=ms)
plot!(xs, bicrit_satisfactions[4].*100, linewidth=lw, labels="DAWN",markershape = :circle,
markerstrokewidth=0,color =:yellow, markersize=ms)
plot!(xs, bicrit_satisfactions[5].*100, linewidth=lw, labels="Walmart",markershape = :circle,
markerstrokewidth=0,color =:green, markersize=ms)
savefig("Plots/GoECC/bicrit_satisfactions.pdf")

title = "GO-ECC Mistakes Above LP"
l_place = :topleft
y_label = "Mistakes"
plot(xs, mistakes_above_lp[1], title = title,
    labels = "Brain",
    grid = false, size = (s1, s2),
    xlabel = x_label, xlim = [0,2], ylabel = y_label, legend = l_place,
    linewidth = lw, markerstrokewidth = 0, markershape = :circle,
    color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
)
plot!(xs, mistakes_above_lp[2], linewidth=lw, labels="MAG-10",markershape = :circle,
markerstrokewidth = 0, color = :black, markersize=ms )
plot!(xs, mistakes_above_lp[3], linewidth=lw, labels="Cooking",markershape = :circle,
markerstrokewidth=0, color =:red, markersize=ms)
plot!(xs, mistakes_above_lp[4], linewidth=lw, labels="DAWN",markershape = :circle,
markerstrokewidth=0,color =:yellow, markersize=ms)
plot!(xs, mistakes_above_lp[5], linewidth=lw, labels="Walmart",markershape = :circle,
markerstrokewidth=0,color =:green, markersize=ms)
savefig("Plots/GoECC/mistakes_above_lp.pdf")

title = "GO-ECC Approximation Factors on t"
l_place = :topleft
y_label = "Approximation Factor"
plot(xs, bicrit_alpha[1], title = title,
    labels = "Brain",
    grid = false, size = (s1, s2),
    xlabel = x_label, xlim = [0,2], ylabel = y_label, legend = l_place,
    linewidth = lw, markerstrokewidth = 0, markershape = :circle,
    color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
)
plot!(xs, bicrit_alpha[2], linewidth=lw, labels="MAG-10",markershape = :circle,
markerstrokewidth = 0, color = :black, markersize=ms )
plot!(xs, bicrit_alpha[3], linewidth=lw, labels="Cooking",markershape = :circle,
markerstrokewidth=0, color =:red, markersize=ms)
plot!(xs, bicrit_alpha[4], linewidth=lw, labels="DAWN",markershape = :circle,
markerstrokewidth=0,color =:yellow, markersize=ms)
plot!(xs, bicrit_alpha[5], linewidth=lw, labels="Walmart",markershape = :circle,
markerstrokewidth=0,color =:green, markersize=ms)
savefig("Plots/GoECC/bicrit_alpha.pdf")

title = "GO-ECC % of Color Budget Used"
l_place = :topleft
y_label = "% of Color Budget Used"
plot(xs, bicrit_beta[1], title = title,
    labels = "Brain",
    grid = false, size = (s1, s2),
    xlabel = x_label, xlim = [0,2], ylabel = y_label, legend = l_place,
    linewidth = lw, markerstrokewidth = 0, markershape = :circle,
    color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
)
plot!(xs, bicrit_beta[2], linewidth=lw, labels="MAG-10",markershape = :circle,
markerstrokewidth = 0, color = :black, markersize=ms )
plot!(xs, bicrit_beta[3], linewidth=lw, labels="Cooking",markershape = :circle,
markerstrokewidth=0, color =:red, markersize=ms)
plot!(xs, bicrit_beta[4], linewidth=lw, labels="DAWN",markershape = :circle,
markerstrokewidth=0,color =:yellow, markersize=ms)
plot!(xs, bicrit_beta[5], linewidth=lw, labels="Walmart",markershape = :circle,
markerstrokewidth=0,color =:green, markersize=ms)
savefig("Plots/GoECC/bicrit_beta.pdf")
