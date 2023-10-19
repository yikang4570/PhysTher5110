import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from scipy import stats
import plotnine as pn
import os

os.chdir("C:/Users/kelop/OneDrive/Documents/GitHub/PhysTher5110/")
os.listdir()

os.listdir("./data")


# 1.0 Plotting Discrete Data
# Load the data
DAT1 = pd.read_csv("./data/data_ANSCOMBE.csv")
print(DAT1.head())

# Regression Coefficients
COEFS = DAT1.groupby('group').agg(
    Intercept=('yVal', lambda x: stats.linregress(x, DAT1.loc[x.index, 'xVal']).intercept),
    Slope=('yVal', lambda x: stats.linregress(x, DAT1.loc[x.index, 'xVal']).slope),
    MeanY=('yVal', 'mean'),
    SDY=('yVal', 'std'),
    MeanX=('xVal', 'mean'),
    SDX=('xVal', 'std')
).reset_index()

print(COEFS)

# Visualizing All the Data
g = sns.FacetGrid(data=DAT1, col='group', col_wrap=2)
g.map_dataframe(sns.scatterplot, x='xVal', y='yVal', hue='group', palette='Set1', marker='o')
g.map_dataframe(sns.regplot, x='xVal', y='yVal', scatter=False, color='k')
g.set_axis_labels("X Values", "Y Values")
g.set_titles("Group {col_name}")
g.set(ylim=(0, 15))
plt.show()

# Disctrete Categorical Data
DAT2 = pd.read_csv("./data/data_FINAL_RATINGS.csv")
print(DAT2.head())

# Just the means
MEANS = DAT2.groupby(['Elevation', 'Speed'])['Effort'].agg(['mean', 'count', 'std']).reset_index()
MEANS.columns = ['Elevation', 'Speed', 'ave_Effort', 'N', 'SD']
print(MEANS)


custom_colors = ["#E69F00", "#56B4E9"]

g = sns.FacetGrid(data=MEANS, col='Speed', sharey=False)
g.map(sns.barplot, 'Elevation', 'ave_Effort', palette=custom_colors)
g.set_axis_labels("Elevation", "Effort (%)")
g.set_titles("Speed {col_name}")
g.set(ylim=(0, 100))
plt.show()
plt.clf()

# Means with Standard errors
e = sns.FacetGrid(data=DAT2, col='Speed', sharey=False)
e.map(sns.barplot, 'Elevation', 'Effort', palette=custom_colors, ci="sd")
e.set_axis_labels("Elevation", "Effort (%)")
e.set_titles("Speed {col_name}")
e.set(ylim=(0, 100))
plt.show()
plt.clf()


# All the data
# Define custom colors
custom_colors = ["#E69F00", "#56B4E9"]

# Create the scatter plot with facets
g = sns.FacetGrid(data=DAT2, col='Speed', hue='Speed', sharey=False)
g.map(sns.scatterplot, 'Elevation', 'Effort', marker='o', palette=custom_colors, s=50, alpha=0.8)
g.set_axis_labels("Elevation", "Effort (%)")
g.despine(left=True, bottom=True)

# Customize font size and style
g.set_titles(size=16, fontweight='bold')
g.set_xticklabels(fontsize=16, color="black")
g.set_yticklabels(fontsize=16, color="black")
g.set_xlabels(fontsize=16, fontweight='bold')
g.set_ylabels(fontsize=16, fontweight='bold')

plt.show()
plt.clf()



# Box Plots
f = sns.stripplot(data=DAT2, x="Elevation", y="Effort", hue="Speed", jitter=0.2, size=5, dodge=0.4)
f = sns.boxplot(data=DAT2, x="Elevation", y="Effort", hue="Speed", boxprops=dict(alpha=.3))

# add title
plt.title("Boxplots with jitter", loc="left")

# show the graph
plt.show()
plt.clf() 
 
 
 
# Connecting the dots...
# Color mapping for Speed
speed_colors = {'Fast': '#E69F00', 'SS': '#56B4E9'}
subj_palette = {subj: 'gray' for subj in DAT2['SUBJ'].unique()}

# Calculate mean Effort for each Elevation and Speed
mean_effort = DAT2.groupby(['Speed', 'Elevation'])['Effort'].mean().reset_index()
print(mean_effort)

# Create subplots based on 'Speed'
speeds = DAT2['Speed'].unique()
fig, axs = plt.subplots(1, len(speeds), figsize=(12, 4))

for i, speed in enumerate(speeds):
    ax = axs[i]

    # Filter the data for the specific speed
    data_subset = DAT2[DAT2['Speed'] == speed]
    
    # Add points
    sns.scatterplot(data=data_subset, x='Elevation', y='Effort', hue='Speed', 
                    ax=ax, palette=speed_colors, legend=False, zorder=2)
    
    # Overlay mean Effort as new data points for the specific 'Speed' category
    mean_effort_subset = mean_effort[mean_effort['Speed'] == speed]
    sns.scatterplot(data=mean_effort_subset, x='Elevation', y='Effort', color='black', marker='s', s=100, 
                    ax=ax, legend=False, zorder=3)

    # Plot lines for each subject
    sns.lineplot(data=data_subset, x='Elevation', y='Effort', hue='SUBJ', style='Speed', markers=True, 
                 ax=ax, palette=subj_palette, zorder=1)

    # Customize the plot
    ax.set_xlabel('Elevation')
    ax.set_ylabel('Effort (%)')
    ax.set_ylim(0, 100)
    ax.set_title(f'Speed: {speed}')
    ax.get_legend().remove()
    
    

# Show the plot
plt.tight_layout()
plt.show()