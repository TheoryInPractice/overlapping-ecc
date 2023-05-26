import mat73
import matplotlib.pyplot as plt

FORMAT = 'pdf'
plt.rcParams.update({'font.size': 22})

datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]
budgets = [0.0, 1.0, 2, 3.0, 4.0]
budget_strings = ['0.0', '1.0', '2.0', '3.0', '4.0']

n = [638, 80198, 6714, 2109, 88837, 207974]

go_useless = []
go_unused = []
go_satisfactions = []
go_mistakes = []
gg_useless = []
gg_unused = []
for i in range(len(datasets)):
    print(i)
    dataset = datasets[i]
    go_useless.append([])
    go_unused.append([])
    go_satisfactions.append([])
    go_mistakes.append([])
    gg_useless.append([])
    gg_unused.append([])
    for j in range(len(budgets)):
        data = mat73.loadmat("Output/stats/goecc"+dataset+"_b"+budget_strings[j]+"_greedycompare.mat")
        go_useless[i].append(data["bicrit_useless"])
        go_unused[i].append(data["bicrit_unused"])
        gg_useless[i].append(data["greedy_useless"])
        gg_unused[i].append(data["greedy_unused"])


        data = mat73.loadmat("Output/GoECC/"+dataset+"_b"+budget_strings[j]+"_results.mat")
        go_satisfactions[i].append(data["satisfaction"])
        go_mistakes[i].append(data["mistakes"])

budgets = [1, 2, 3, 4, 5]
lo_useless = []
lo_unused = []
lo_satisfactions = []
lo_mistakes = []
lg_useless = []
lg_unused = []
for i in range(len(datasets)):
    dataset = datasets[i]
    lo_useless.append([])
    lo_unused.append([])
    lo_satisfactions.append([])
    lo_mistakes.append([])
    lg_useless.append([])
    lg_unused.append([])
    for b in budgets:
        data = mat73.loadmat("Output/stats/loecc"+dataset+"_b"+str(b)+"_greedycompare.mat")
        lo_useless[i].append(data["bicrit_useless"])
        lo_unused[i].append(data["bicrit_unused"])
        lg_useless[i].append(data["greedy_useless"])
        lg_unused[i].append(data["greedy_unused"])

        data = mat73.loadmat("Output/LoECC/"+dataset+"_b"+str(b)+"_results.mat")
        lo_satisfactions[i].append(data["bicrit_satisfaction"])
        lo_mistakes[i].append(data["bicrit_mistakes"])

useless_improvement_percentages = []
unused_improvement_percentages = []
satisfaction_improvement_absolute = []
mistake_reduction_percentages = []

llplg_useless_improvement_percentages = []
llplg_unused_improvement_percentages = []
glpgg_useless_improvement_percentages = []
glpgg_unused_improvement_percentages = []

for i in range(len(datasets)):
    useless_improvement_percentages.append([])
    satisfaction_improvement_absolute.append([])
    mistake_reduction_percentages.append([])
    unused_improvement_percentages.append([])

    llplg_useless_improvement_percentages.append([])
    llplg_unused_improvement_percentages.append([])
    glpgg_useless_improvement_percentages.append([])
    glpgg_unused_improvement_percentages.append([])
    for j in range(len(budgets)):
        useless_improvement_percentages[i].append(100.0*(lo_useless[i][j] - go_useless[i][j])/float(lo_useless[i][j]))
        satisfaction_improvement_absolute[i].append((go_satisfactions[i][j] - lo_satisfactions[i][j])*100)
        mistake_reduction_percentages[i].append(100.0*(lo_mistakes[i][j] - go_mistakes[i][j])/lo_mistakes[i][j])
        unused_improvement_percentages[i].append(100.0*(lo_unused[i][j] - go_unused[i][j])/lo_unused[i][j])
        
        llplg_useless_improvement_percentages[i].append(100.0*(lg_useless[i][j] - lo_useless[i][j])/lg_useless[i][j])
        llplg_unused_improvement_percentages[i].append(100.0*(lg_unused[i][j] - lo_unused[i][j])/lg_unused[i][j])

        glpgg_useless_improvement_percentages[i].append(100.0*(gg_useless[i][j] - go_useless[i][j])/gg_useless[i][j])
        glpgg_unused_improvement_percentages[i].append(100.0*(gg_unused[i][j] - go_unused[i][j])/gg_unused[i][j])

orange = [x/255.0 for x in [230, 159, 0]]
skyblue = [x/255.0 for x in [86, 180, 233]]
bluegreen = [x/255.0 for x in [0, 158, 115]]
blue = [x/255.0 for x in [0, 114, 178]]
vermillion = [x/255.0 for x in [213, 94, 0]]
redpurple = [x/255.0 for x in [204, 121, 167]]

colors = [orange, skyblue, bluegreen, redpurple, vermillion, blue]
legend_text = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart", "Trivago"]
markers = ['^', 'v', 'o', 's', '<', '>']
x = [1, 2, 3, 4, 5]

fig, ax = plt.subplots()
for i in range(len(datasets)):
    ax.plot(x, satisfaction_improvement_absolute[i], label=legend_text[i], color=colors[i], marker=markers[i])
ax.set_xlabel("Ave. # Colors per Node")
ax.set_ylabel("Differnce in Sat %")
ax.legend(fontsize=16)
fig.savefig(f'Plots/golo_satisfaction_improvements.{FORMAT}', format=FORMAT, bbox_inches='tight')

fig, ax = plt.subplots()
for i in range(len(datasets)):
    ax.plot(x, mistake_reduction_percentages[i], label=legend_text[i], color=colors[i], marker=markers[i])
ax.set_xlabel("Ave. # Colors per Node")
ax.set_ylabel("Mistake Reduction %")
ax.legend(fontsize=16)
fig.savefig(f'Plots/golo_mistake_reduction_percentages.{FORMAT}', format=FORMAT, bbox_inches='tight')

fig, ax = plt.subplots()
for i in range(len(datasets)):
    ax.plot(x, useless_improvement_percentages[i], label=legend_text[i], color=colors[i], marker=markers[i])
ax.set_xlabel("Ave. # Colors per Node")
ax.set_ylabel("Useless % Reduction")
ax.legend(fontsize=16)
fig.savefig(f'Plots/golo_useless_reduction_percentages.{FORMAT}', format=FORMAT, bbox_inches='tight')

fig, ax = plt.subplots()
for i in range(len(datasets)):
    ax.plot(x, unused_improvement_percentages[i], label=legend_text[i], color=colors[i], marker=markers[i])
ax.set_xlabel("Ave. # Colors per Node")
ax.set_ylabel("Unused % Reduction")
ax.legend(fontsize=16)
fig.savefig(f'Plots/golo_unused_reduction_percentages.{FORMAT}', format=FORMAT, bbox_inches='tight')

fig, ax = plt.subplots()
for i in range(len(datasets)):
    ax.plot(x, llplg_useless_improvement_percentages[i], label=legend_text[i], color=colors[i], marker=markers[i])
ax.set_xlabel("Ave. # Colors per Node")
ax.set_ylabel("Useless % Reduction")
ax.legend(fontsize=16)
fig.savefig(f'Plots/llplg_useless_reduction_percentages.{FORMAT}', format=FORMAT, bbox_inches='tight')

fig, ax = plt.subplots()
for i in range(len(datasets)):
    ax.plot(x, llplg_unused_improvement_percentages[i], label=legend_text[i], color=colors[i], marker=markers[i])
ax.set_xlabel("Ave. # Colors per Node")
ax.set_ylabel("Unused % Reduction")
ax.legend(fontsize=16)
fig.savefig(f'Plots/llplg_unused_reduction_percentages.{FORMAT}', format=FORMAT, bbox_inches='tight')

fig, ax = plt.subplots()
for i in range(len(datasets)):
    ax.plot(x, glpgg_useless_improvement_percentages[i], label=legend_text[i], color=colors[i], marker=markers[i])
ax.set_xlabel("Ave. # Colors per Node")
ax.set_ylabel("Useless % Reduction")
ax.legend(fontsize=16)
fig.savefig(f'Plots/glpgg_useless_reduction_percentages.{FORMAT}', format=FORMAT, bbox_inches='tight')

fig, ax = plt.subplots()
for i in range(len(datasets)):
    ax.plot(x, glpgg_unused_improvement_percentages[i], label=legend_text[i], color=colors[i], marker=markers[i])
ax.set_xlabel("Ave. # Colors per Node")
ax.set_ylabel("Unused % Reduction")
ax.legend(fontsize=16)
fig.savefig(f'Plots/glpgg_unused_reduction_percentages.{FORMAT}', format=FORMAT, bbox_inches='tight')