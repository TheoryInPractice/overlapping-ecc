import mat73
import matplotlib.pyplot as plt
import numpy as np

FORMAT = 'pdf'
plt.rcParams.update({'font.size': 22})

datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]
colors = [1, 2, 3, 4, 5, 8, 16, 32]
guarantees = [2 - 1/float(color) for color in colors]

n = [638, 80198, 6714, 2109, 88837, 207974]
M = [21180, 51889, 39774, 87104, 65898, 247362]

bicrit_mistakes = []
bicrit_lp_mistakes = []
bicrit_apx = []
bicrit_beta = []
for i in range(len(datasets)):
    dataset = datasets[i]
    bicrit_mistakes.append([])
    bicrit_lp_mistakes.append([])
    bicrit_apx.append([])
    bicrit_beta.append([])
    for b in colors:
        data = mat73.loadmat("Output/LoECC/"+dataset+"_b"+str(b)+"_results.mat")
        bicrit_mistakes[i].append(data["bicrit_mistakes"])
        bicrit_lp_mistakes[i].append(data["bicrit_LPval"])
        bicrit_apx[i].append(data["bicrit_ratio"])
        bicrit_beta[i].append(data["bicrit_budget_ratio"])

bicrit_percent_of_possible_sat = []
for i in range(len(datasets)):
    bicrit_percent_of_possible_sat.append([])
    for j in range(len(colors)):
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
x = [1, 2, 4, 4, 5, 8, 16, 32]
for i in range(len(datasets)):
    ax.plot(x, bicrit_apx[i], label=legend_text[i], color=colors[i], marker=markers[i])
ax.set_xlabel(r"$b$ = Local Budget")
ax.set_ylabel(r"Observed $\alpha$")
ax.legend(fontsize=16)
fig.savefig(f'Plots/lo_alphas.{FORMAT}', format=FORMAT, bbox_inches='tight')

fig2, ax2 = plt.subplots()
for i in range(len(datasets)):
    ax2.plot(x, bicrit_percent_of_possible_sat[i], label=legend_text[i], color=colors[i],marker=markers[i])
ax2.set_xlabel(r"$b$ = Local Budget")
ax2.set_ylabel("Satisfied Edges (% of UB)")
ax2.legend(fontsize=16)
ax2.ticklabel_format(axis='y', useOffset=100.0)
ax2.set_yticks(ticks=[99.85, 99.90, 99.95, 100.00], labels=['99.85', '99.90', '99.95', '100.0'])
fig2.savefig(f'Plots/lo_satisfied_percent_of_upper_bound.{FORMAT}', format=FORMAT, bbox_inches='tight')

fig3, ax3 = plt.subplots()
upper_bound_x = np.linspace(1, 32, 1000)
guarantees = [2.0 - 1/b for b in upper_bound_x]
ax3.plot(upper_bound_x, guarantees, label="Upper Bound", color="black")
ax3.plot(x, bicrit_beta[5], label=legend_text[5], color=colors[i],marker=markers[5])
ax3.set_xlabel(r"$b$ = Local Budget")
ax3.set_ylabel(r"Observed $\beta$")
ax3.legend(fontsize=16)
fig3.savefig(f'Plots/lo_trivago_betas.{FORMAT}', format=FORMAT, bbox_inches='tight')