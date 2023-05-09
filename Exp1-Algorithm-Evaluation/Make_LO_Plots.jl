using MAT
using Plots
using Measures

datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]
colors = [1, 2, 3, 4, 5, 8, 16, 32]

bp1_mistakes = []
bp1_satisfactions = []
bp1_lp_mistakes = []
bp1_apx = []

bicrit_mistakes = []
bicrit_satisfactions = []
bicrit_lp_mistakes = []
bicrit_apx = []
bicrit_budget_usage = []

n = [638, 80198, 6714, 2109, 88837, 207974]


for i = 1:length(datasets)
    dataset = datasets[i]
    push!(bp1_mistakes, [])
    push!(bp1_satisfactions, [])
    push!(bicrit_mistakes, [])
    push!(bicrit_satisfactions, [])
    push!(bp1_lp_mistakes, [])
    push!(bp1_apx, [])
    push!(bicrit_lp_mistakes, [])
    push!(bicrit_apx, [])
    push!(bicrit_budget_usage, [])
    for j = 1:length(colors)
        bstring = string(colors[j])
        data = matread("/scratch/tmp/crane/overlapping-ecc/LoECC/"*dataset*"_b"*bstring*"_results.mat")
        push!(bp1_mistakes[i], data["bplusone_mistakes"])
        push!(bp1_satisfactions[i], data["bplusone_satisfaction"])
        push!(bicrit_mistakes[i], data["bicrit_mistakes"])
        push!(bicrit_satisfactions[i], data["bicrit_satisfaction"])
        push!(bp1_lp_mistakes[i], data["LPval"])
        push!(bp1_apx[i], data["bplusone_ratio"])
        push!(bicrit_lp_mistakes[i], data["bicrit_LPval"])
        push!(bicrit_apx[i], data["bicrit_ratio"])
        push!(bicrit_budget_usage[i], data["bicrit_budget_ratio"])
    end
end

mistake_differences = []
apx_differences = []
bp1_mistakes_above_lp = []
bicrit_mistakes_above_lp = []
bicrit_mistakes_above_percent = []
for i = 1:length(datasets)
    push!(mistake_differences, [])
    push!(apx_differences, [])
    push!(bp1_mistakes_above_lp, [])
    push!(bicrit_mistakes_above_lp, [])
    push!(bicrit_mistakes_above_percent, [])

    for j = 1:length(colors)
        push!(mistake_differences[i], bp1_mistakes[i][j] - bicrit_mistakes[i][j])
        push!(apx_differences[i], bp1_apx[i][j] - bicrit_apx[i][j])
        push!(bp1_mistakes_above_lp[i], bp1_mistakes[i][j] - bp1_lp_mistakes[i][j])
        push!(bicrit_mistakes_above_lp[i], bicrit_mistakes[i][j] - bicrit_lp_mistakes[i][j])
        push!(bicrit_mistakes_above_lp[i], bicrit_mistakes_above_lp[i][j] / n[i])

    end
end

# xs = colors
# x_label = "b = local budget"
# y_label = "mistakes"
# l_place = :topright
# s1 = 300
# s2 = 250
# ms = 5
# lw = 2
# title = "LO-ECC Single Criteria Mistakes"
# plot(xs, bp1_mistakes[1], title = title,
#     labels = "Brain",
#     grid = false, size = (s1, s2),
#     xlabel = x_label, xlim = [0,32], ylabel = y_label, legend = l_place,
#     linewidth = lw, markerstrokewidth = 0, markershape = :circle,
#     color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
# )
# plot!(xs, bp1_mistakes[2], linewidth=lw, labels="MAG-10",markershape = :circle,
# markerstrokewidth = 0, color = :black, markersize=ms )
# plot!(xs, bp1_mistakes[3], linewidth=lw, labels="Cooking",markershape = :circle,
# markerstrokewidth=0, color =:red, markersize=ms)
# plot!(xs, bp1_mistakes[4], linewidth=lw, labels="DAWN",markershape = :circle,
# markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, bp1_mistakes[5], linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
# savefig("Plots/bp1_mistakes.pdf")

# s1 = 300
# s2 = 250
# ms = 5
# lw = 2
# y_label = "Edge Satisfaction %"
# x_label = "b = local budget"
# # title = "LO-ECC Single Criteria Satisfaction"
# l_place = :bottomright
# plot(xs, bp1_satisfactions[1].*100, title = title,
#     labels = "Brain",
#     grid = false, size = (s1, s2),
#     xlabel = x_label, xlim = [0,32], ylabel = y_label, legend = l_place,
#     linewidth = lw, markerstrokewidth = 0, markershape = :circle,
#     color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
# )
# plot!(xs, bp1_satisfactions[2].*100, linewidth=lw, labels="MAG-10",markershape = :circle,
# markerstrokewidth = 0, color = :black, markersize=ms )
# plot!(xs, bp1_satisfactions[3].*100, linewidth=lw, labels="Cooking",markershape = :circle,
# markerstrokewidth=0, color =:red, markersize=ms)
# plot!(xs, bp1_satisfactions[4].*100, linewidth=lw, labels="DAWN",markershape = :circle,
# markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, bp1_satisfactions[5].*100, linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
# savefig("Plots/bp1_satisfactions.pdf")

# y_label = "Mistakes"
# title = "LO-ECC Bi-Criteria Mistakes"
# x_label = "b = Local budget"
# l_place = :topright
# plot(xs, bicrit_mistakes[1], title = title,
#     labels = "Brain",
#     grid = false, size = (s1, s2),
#     xlabel = x_label, xlim = [0,32], ylabel = y_label, legend = l_place,
#     linewidth = lw, markerstrokewidth = 0, markershape = :circle,
#     color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
# )
# plot!(xs, bicrit_mistakes[2], linewidth=lw, labels="MAG-10",markershape = :circle,
# markerstrokewidth = 0, color = :black, markersize=ms )
# plot!(xs, bicrit_mistakes[3], linewidth=lw, labels="Cooking",markershape = :circle,
# markerstrokewidth=0, color =:red, markersize=ms)
# plot!(xs, bicrit_mistakes[4], linewidth=lw, labels="DAWN",markershape = :circle,
# markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, bicrit_mistakes[5], linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
# savefig("Plots/bicrit_mistakes.pdf")


# y_label = "Edge Satisfaction %"
# title = "LO-ECC Bi-Criteria Satisfaction"
# l_place = :bottomright
# plot(xs, bicrit_satisfactions[1].*100, title = title,
#     labels = "Brain",
#     grid = false, size = (s1, s2),
#     xlabel = x_label, xlim = [0,32], ylabel = y_label, legend = l_place,
#     linewidth = lw, markerstrokewidth = 0, markershape = :circle,
#     color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
# )
# plot!(xs, bicrit_satisfactions[2].*100, linewidth=lw, labels="MAG-10",markershape = :circle,
# markerstrokewidth = 0, color = :black, markersize=ms )
# plot!(xs, bicrit_satisfactions[3].*100, linewidth=lw, labels="Cooking",markershape = :circle,
# markerstrokewidth=0, color =:red, markersize=ms)
# plot!(xs, bicrit_satisfactions[4].*100, linewidth=lw, labels="DAWN",markershape = :circle,
# markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, bicrit_satisfactions[5].*100, linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
# savefig("Plots/bicrit_satisfactions.pdf")

# y_label = "bp1 mistakes - bicrit mistakes"
# title = "LO-ECC bp1 mistakes - Bi-Criteria mistakes"
# l_place = :bottomright
# plot(xs, mistake_differences[1], title = title,
#     labels = "Brain",
#     grid = false, size = (s1, s2),
#     xlabel = x_label, xlim = [0,32], ylabel = y_label, legend = l_place,
#     linewidth = lw, markerstrokewidth = 0, markershape = :circle,
#     color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
# )
# plot!(xs, mistake_differences[2], linewidth=lw, labels="MAG-10",markershape = :circle,
# markerstrokewidth = 0, color = :black, markersize=ms )
# plot!(xs, mistake_differences[3], linewidth=lw, labels="Cooking",markershape = :circle,
# markerstrokewidth=0, color =:red, markersize=ms)
# plot!(xs, mistake_differences[4], linewidth=lw, labels="DAWN",markershape = :circle,
# markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, mistake_differences[5], linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
# savefig("Plots/mistake_differences.pdf")


# y_label = "bp1 apx - bicrit apx"
# title = "LO-ECC difference in approximation factors"
# l_place = :bottomright
# plot(xs, apx_differences[1], title = title,
#     labels = "Brain",
#     grid = false, size = (s1, s2),
#     xlabel = x_label, xlim = [0,32], ylabel = y_label, legend = l_place,
#     linewidth = lw, markerstrokewidth = 0, markershape = :circle,
#     color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
# )
# plot!(xs, apx_differences[2], linewidth=lw, labels="MAG-10",markershape = :circle,
# markerstrokewidth = 0, color = :black, markersize=ms )
# plot!(xs, apx_differences[3], linewidth=lw, labels="Cooking",markershape = :circle,
# markerstrokewidth=0, color =:red, markersize=ms)
# plot!(xs, apx_differences[4], linewidth=lw, labels="DAWN",markershape = :circle,
# markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, apx_differences[5], linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
# savefig("Plots/apx_differences.pdf")

# y_label = "bp1 apx - bicrit apx"
# title = "LO-ECC difference in approximation factors"
# l_place = :bottomright
# plot(xs, apx_differences[1], title = title,
#     labels = "Brain",
#     grid = false, size = (s1, s2),
#     xlabel = x_label, xlim = [0,32], ylabel = y_label, legend = l_place,
#     linewidth = lw, markerstrokewidth = 0, markershape = :circle,
#     color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
# )
# plot!(xs, apx_differences[2], linewidth=lw, labels="MAG-10",markershape = :circle,
# markerstrokewidth = 0, color = :black, markersize=ms )
# plot!(xs, apx_differences[3], linewidth=lw, labels="Cooking",markershape = :circle,
# markerstrokewidth=0, color =:red, markersize=ms)
# plot!(xs, apx_differences[4], linewidth=lw, labels="DAWN",markershape = :circle,
# markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, apx_differences[5], linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
# savefig("Plots/apx_differences.pdf")

# y_label = "Mistakes above LP"
# title = "LO-ECC b plus one mistakes above lp"
# l_place = :topright
# plot(xs, bp1_mistakes_above_lp[1], title = title,
#     labels = "Brain",
#     grid = false, size = (s1, s2),
#     xlabel = x_label, xlim = [0,32], ylabel = y_label, legend = l_place,
#     linewidth = lw, markerstrokewidth = 0, markershape = :circle,
#     color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
# )
# plot!(xs, bp1_mistakes_above_lp[2], linewidth=lw, labels="MAG-10",markershape = :circle,
# markerstrokewidth = 0, color = :black, markersize=ms )
# plot!(xs, bp1_mistakes_above_lp[3], linewidth=lw, labels="Cooking",markershape = :circle,
# markerstrokewidth=0, color =:red, markersize=ms)
# plot!(xs, bp1_mistakes_above_lp[4], linewidth=lw, labels="DAWN",markershape = :circle,
# markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, bp1_mistakes_above_lp[5], linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
# savefig("Plots/bp1_mistakes_above_lp.pdf")

# y_label = "Mistakes above LP"
# title = "LO-ECC bi-criteria mistakes above lp"
# l_place = :topright
# plot(xs, bicrit_mistakes_above_lp[1], title = title,
#     labels = "Brain",
#     grid = false, size = (s1, s2),
#     xlabel = x_label, xlim = [0,32], ylabel = y_label, legend = l_place,
#     linewidth = lw, markerstrokewidth = 0, markershape = :circle,
#     color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
# )
# plot!(xs, bicrit_mistakes_above_lp[2], linewidth=lw, labels="MAG-10",markershape = :circle,
# markerstrokewidth = 0, color = :black, markersize=ms )
# plot!(xs, bicrit_mistakes_above_lp[3], linewidth=lw, labels="Cooking",markershape = :circle,
# markerstrokewidth=0, color =:red, markersize=ms)
# plot!(xs, bicrit_mistakes_above_lp[4], linewidth=lw, labels="DAWN",markershape = :circle,
# markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, bicrit_mistakes_above_lp[5], linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
# savefig("Plots/bicrit_mistakes_above_lp.pdf")

# y_label = "Approximation Factor"
# title = "LO-ECC b+1 Approximation Factors"
# l_place = :topright
# plot(xs, bp1_apx[1], title = title,
#     labels = "Brain",
#     grid = false, size = (s1, s2),
#     xlabel = x_label, xlim = [0,32], ylabel = y_label, legend = l_place,
#     linewidth = lw, markerstrokewidth = 0, markershape = :circle,
#     color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
# )
# plot!(xs, bp1_apx[2], linewidth=lw, labels="MAG-10",markershape = :circle,
# markerstrokewidth = 0, color = :black, markersize=ms )
# plot!(xs, bp1_apx[3], linewidth=lw, labels="Cooking",markershape = :circle,
# markerstrokewidth=0, color =:red, markersize=ms)
# plot!(xs, bp1_apx[4], linewidth=lw, labels="DAWN",markershape = :circle,
# markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, bp1_apx[5], linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
# savefig("Plots/bp1_apx.pdf")

xs = colors
s1 = 300
s2 = 250
ms = 5
lw = 2
y_label = "Approximation Factor"
x_label = "b = Local Budget"
# title = "LO-ECC Bi-Criteria Approximation Factors on t"
l_place = :topright
plot(xs, bicrit_apx[1],
    labels = "Brain",
    grid = false, size = (s1, s2),
    xlabel = x_label, xlim = [0,32], ylabel = y_label, legend = l_place,
    linewidth = lw, markerstrokewidth = 0, markershape = :circle,
    color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
)
plot!(xs, bicrit_apx[2], linewidth=lw, labels="MAG-10",markershape = :circle,
markerstrokewidth = 0, color = :black, markersize=ms )
plot!(xs, bicrit_apx[3], linewidth=lw, labels="Cooking",markershape = :circle,
markerstrokewidth=0, color =:red, markersize=ms)
plot!(xs, bicrit_apx[4], linewidth=lw, labels="DAWN",markershape = :circle,
markerstrokewidth=0,color =:yellow, markersize=ms)
plot!(xs, bicrit_apx[5], linewidth=lw, labels="Walmart",markershape = :circle,
markerstrokewidth=0,color =:green, markersize=ms)
plot!(xs, bicrit_apx[5], linewidth=lw, labels="Trivago",markershape = :circle,
markerstrokewidth=0,color =:purple, markersize=ms)
savefig("Plots/lo_alphas.pdf")

xs = colors
s1 = 300
s2 = 250
ms = 5
lw = 2
y_label = "Extra Mistakes (% of Edges)"
x_label = "b = Local Budget"
# title = "LO-ECC Bi-Criteria Approximation Factors on t"
l_place = :topright
plot(xs, bicrit_mistakes_above_percent[1],
    labels = "Brain",
    grid = false, size = (s1, s2),
    xlabel = x_label, xlim = [0,32], ylabel = y_label, legend = l_place,
    linewidth = lw, markerstrokewidth = 0, markershape = :circle,
    color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
)
plot!(xs, bicrit_mistakes_above_percent[2], linewidth=lw, labels="MAG-10",markershape = :circle,
markerstrokewidth = 0, color = :black, markersize=ms )
plot!(xs, bicrit_mistakes_above_percent[3], linewidth=lw, labels="Cooking",markershape = :circle,
markerstrokewidth=0, color =:red, markersize=ms)
plot!(xs, bicrit_mistakes_above_percent[4], linewidth=lw, labels="DAWN",markershape = :circle,
markerstrokewidth=0,color =:yellow, markersize=ms)
plot!(xs, bicrit_mistakes_above_percent[5], linewidth=lw, labels="Walmart",markershape = :circle,
markerstrokewidth=0,color =:green, markersize=ms)
plot!(xs, bicrit_mistakes_above_percent[5], linewidth=lw, labels="Trivago",markershape = :circle,
markerstrokewidth=0,color =:purple, markersize=ms)
savefig("Plots/lo_extra_mistake_percentages.pdf")

# y_label = "Largest % of Local Budget Used"
# title = "LO-ECC Bi-Criteria Budget Usage"
# l_place = :topright
# plot(xs, bicrit_budget_usage[1], title = title,
#     labels = "Brain",
#     grid = false, size = (s1, s2),
#     xlabel = x_label, xlim = [0,32], ylabel = y_label, legend = l_place,
#     linewidth = lw, markerstrokewidth = 0, markershape = :circle,
#     color = :blue, markersize = ms, margin = 10mm, titlefontsize=10
# )
# plot!(xs, bicrit_budget_usage[2], linewidth=lw, labels="MAG-10",markershape = :circle,
# markerstrokewidth = 0, color = :black, markersize=ms )
# plot!(xs, bicrit_budget_usage[3], linewidth=lw, labels="Cooking",markershape = :circle,
# markerstrokewidth=0, color =:red, markersize=ms)
# plot!(xs, bicrit_budget_usage[4], linewidth=lw, labels="DAWN",markershape = :circle,
# markerstrokewidth=0,color =:yellow, markersize=ms)
# plot!(xs, bicrit_budget_usage[5], linewidth=lw, labels="Walmart",markershape = :circle,
# markerstrokewidth=0,color =:green, markersize=ms)
# savefig("Plots/bicrit_budget_usage.pdf")