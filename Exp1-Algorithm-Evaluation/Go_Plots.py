import mat73
import matplotlib.pyplot as plt

FORMAT = 'pdf'
plt.rcParams.update({'font.size': 22})

datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]
budgets = [0.0, 0.5, 1.0, 1.5, 2, 2.5, 3.0, 3.5, 4.0]
budget_strings = ['0.0', '0.5', '1.0', '1.5', '2.0', '2.5', '3.0', '3.5', '4.0']

n = [638, 80198, 6714, 2109, 88837, 207974]
M = [21180, 51889, 39774, 87104, 65898, 247362]

bicrit_mistakes = []
bicrit_lp_mistakes = []
bicrit_apx = []
for i in range(len(datasets)):
    print(i)
    dataset = datasets[i]
    bicrit_mistakes.append([])
    bicrit_lp_mistakes.append([])
    bicrit_apx.append([])
    for j in range(len(budgets)):
        data = mat73.loadmat("Output/GoECC/"+dataset+"_b"+budget_strings[j]+"_results.mat")
        bicrit_mistakes[i].append(data["mistakes"])
        bicrit_lp_mistakes[i].append(data["LPval"])
        bicrit_apx[i].append(data["ratio"])

bicrit_percent_of_possible_sat = []
for i in range(len(datasets)):
    bicrit_percent_of_possible_sat.append([])
    for j in range(len(budgets)):
        satisfaction_upper_bound = M[i] - bicrit_lp_mistakes[i][j]
        bicrit_satisfied = M[i] - bicrit_mistakes[i][j]
        bicrit_percent_of_possible_sat[i].append((bicrit_satisfied/satisfaction_upper_bound))
    
    bicrit_percent_of_possible_sat[i] = [100*p for p in bicrit_percent_of_possible_sat[i]]

legend_text = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart", "Trivago"]
markers = ['^', 'v', 'o', 's', '<', '>']


orange = [x/255.0 for x in [230, 159, 0]]
skyblue = [x/255.0 for x in [86, 180, 233]]
bluegreen = [x/255.0 for x in [0, 158, 115]]
blue = [x/255.0 for x in [0, 114, 178]]
vermillion = [x/255.0 for x in [213, 94, 0]]
redpurple = [x/255.0 for x in [204, 121, 167]]

colors = [orange, skyblue, bluegreen, redpurple, vermillion, blue]


fig, ax = plt.subplots()
x = [100*budg for budg in budgets]
for i in range(len(datasets)):
    ax.plot(x, bicrit_apx[i], label=legend_text[i], color=colors[i], marker=markers[i])
ax.set_xlabel(r"$b$ = Global Budget (% of $V$)")
ax.set_ylabel(r"Observed $\alpha$")
ax.legend(fontsize=16)
fig.savefig(f'Plots/go_alphas.{FORMAT}', format=FORMAT, bbox_inches='tight')

fig2, ax2 = plt.subplots()
for i in range(len(datasets)):
    ax2.plot(x, bicrit_percent_of_possible_sat[i], label=legend_text[i], color=colors[i],marker=markers[i])
ax2.set_xlabel(r"$b$ = Global Budget (% of $V$)")
ax2.set_ylabel("Satisfied Edges (% of UB)")
ax2.legend(fontsize=16)
ax2.ticklabel_format(axis='y', useOffset=100.0)
ax2.set_yticks(ticks=[99.85, 99.90, 99.95, 100.00], labels=['99.85', '99.90', '99.95', '100.0'])
fig2.savefig(f'Plots/go_satisfied_percent_of_upper_bound.{FORMAT}', format=FORMAT, bbox_inches='tight')
    