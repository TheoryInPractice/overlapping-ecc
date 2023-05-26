import mat73
import matplotlib.pyplot as plt

FORMAT = 'pdf'
plt.rcParams.update({'font.size': 22})

datasets = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart-Trips", "Trivago"]
budgets = [0, .01, .05, .1, .15, .2, .25]
budget_strings = ['0.0', '0.01', '0.05', '0.1', '0.15', '0.2', '0.25']

n = [638, 80198, 6714, 2109, 88837, 207974]

bicrit_apx = []
bicrit_beta = []
greedy_satisfaction = []

for i in range(len(datasets)):
    print(i)
    dataset = datasets[i]
    bicrit_apx.append([])
    bicrit_beta.append([])
    greedy_satisfaction.append([])
    for j in range(len(budgets)):
        data = mat73.loadmat("Output/RECC/"+dataset+"_b"+budget_strings[j]+"_results.mat")
        bicrit_apx[i].append(data["ratio"])
        bicrit_beta[i].append(data["budget_ratio"])
        greedy_satisfaction[i].append(100*data["greedy_satisfaction"])

orange = [x/255.0 for x in [230, 159, 0]]
skyblue = [x/255.0 for x in [86, 180, 233]]
bluegreen = [x/255.0 for x in [0, 158, 115]]
blue = [x/255.0 for x in [0, 114, 178]]
vermillion = [x/255.0 for x in [213, 94, 0]]
redpurple = [x/255.0 for x in [204, 121, 167]]

colors = [orange, skyblue, bluegreen, redpurple, vermillion, blue]
legend_text = ["Brain", "MAG-10", "Cooking", "DAWN", "Walmart", "Trivago"]
markers = ['^', 'v', 'o', 's', '<', '>']

fig, ax = plt.subplots()
x = [budg*100 for budg in budgets]
for i in range(len(datasets)):
    ax.plot(x, bicrit_apx[i], label=legend_text[i], color=colors[i], marker=markers[i])
ax.set_xlabel(r"$b$ = Deletion Budget (% of $V$)")
ax.set_ylabel(r"Observed $\alpha$")
ax.legend(fontsize=16)
fig.savefig(f'Plots/r_alphas.{FORMAT}', format=FORMAT, bbox_inches='tight')

fig2, ax2 = plt.subplots()
for i in range(len(datasets)):
    ax2.plot(x, bicrit_beta[i], label=legend_text[i], color=colors[i],marker=markers[i])
ax2.set_xlabel(r"$b$ = Deletion Budget (% of $V$)")
ax2.set_ylabel(r"Observed $\beta$")
ax2.legend(fontsize=16)
fig2.savefig(f'Plots/r_betas.{FORMAT}', format=FORMAT, bbox_inches='tight')

fig3, ax3 = plt.subplots()
for i in range(len(datasets)):
    ax3.plot(x, greedy_satisfaction[i], label=legend_text[i], color=colors[i],marker=markers[i])
ax3.set_xlabel(r"$b$ = Deletion Budget (% of $V$)")
ax3.set_ylabel(r"Edge Satisfaction (% of $E$)")
ax3.legend(fontsize=16)
fig3.savefig(f'Plots/r_greedy_satisfactions.{FORMAT}', format=FORMAT, bbox_inches='tight')

    