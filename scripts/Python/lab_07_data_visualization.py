import pandas as pd
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt
import seaborn as sns
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
g.set(ylim=(0, 12))
plt.legend(title="Group", loc='upper right', bbox_to_anchor=(1.15, 1.0))
plt.show()

# Disctrete Categorical Data
DAT2 = pd.read_csv("./data_FINAL_RATINGS.csv")
print(DAT2.head())

# Just the means
MEANS = DAT2.groupby(['Elevation', 'Speed'])['Effort'].agg(['mean', 'count', 'std']).reset_index()
MEANS.columns = ['Elevation', 'Speed', 'ave_Effort', 'N', 'SD']
print(MEANS)

g = sns.FacetGrid(data=MEANS, col='Speed', sharey=False)
g.map(sns.barplot, 'Elevation', 'ave_Effort', palette='Set1')
g.set_axis_labels("Elevation", "Effort (%)")
g.set_titles("Speed {col_name}")
g.set(ylim=(0, 100))
plt.show()

# Means with Standard errors
g = sns.FacetGrid(data=MEANS, col='Speed', sharey=False)
g.map(sns.barplot, 'Elevation', 'ave_Effort', palette='Set1', ci="sd", errcolor="k")
g.set_axis_labels("Elevation", "Effort (%)")
g.set_titles("Speed {col_name}")
g.set(ylim=(0, 100))
plt.show()

# All the data
g = sns.FacetGrid(data=DAT2, col='Speed', sharey=False)
g.map(sns.scatterplot, 'Elevation', 'Effort', hue='Elevation', palette='Set1', marker='o')
g.set_axis_labels("Elevation", "Effort (%)")
g.set_titles("Speed {col_name}")
g.set(ylim=(0, 100))
plt.legend(title="Elevation", loc='upper right', bbox_to_anchor=(1.15, 1.0))
plt.show()

# Boxplots
g = sns.FacetGrid(data=DAT2, col='Speed', sharey=False)
g.map(sns.boxplot, 'Elevation', 'Effort', hue='Elevation', palette='Set1', dodge=False)
g.set_axis_labels("Elevation", "Effort (%)")
g.set_titles("Speed {col_name}")
g.set(ylim=(0, 100))
plt.legend(title="Elevation", loc='upper right', bbox_to_anchor=(1.15, 1.0))
plt.show()

# Connect the dots
DAT3 = DAT2.groupby(['Elevation', 'Speed'])['Effort'].mean().reset_index()
print(DAT3)

g = sns.FacetGrid(data=DAT2, col='Speed', sharey=False)
g.map(sns.lineplot, 'Elevation', 'Effort', hue='Elevation', palette='Set1', marker='o')
g.set_axis_labels("Elevation", "Effort (%)")
g.set_titles("Speed {col_name}")
g.set(ylim=(0, 100))
plt.legend(title="Elevation", loc='upper right', bbox_to_anchor=(1.15, 1.0))
sns.lineplot(data=DAT3, x='Elevation', y='Effort', hue='Elevation', palette='Set1', lw=2)
plt.legend(title="Elevation", loc='upper right', bbox_to_anchor=(1.15, 1.0))
plt.show()

# 2.0 Visualizing Continuous Data
# Acquisition Data
ACQ = pd.read_csv("./data_CI_ERRORS.csv", na_values=['NA', 'NaN', ' '])
ACQ['subID'] = ACQ['subID'].astype('category')
ACQ['target_nom'] = ACQ['target'].astype('category')

# Removing Outliers
ACQ = ACQ[ACQ['absolute_error'] < 1000]
print(ACQ.head())

g = sns.FacetGrid(data=ACQ, col='group', sharey=False)
g.map(sns.kdeplot, 'target+constant_error', hue='target_nom', fill=True, common_norm=False, palette='Set1', alpha=0.4)
g.set_axis_labels("Time Produced (ms)", "Density")
g.set_titles("Group {col_name}")
g.set(ylim=(0, 0.003))
g.add_legend(title="Target (ms)", loc='upper right', bbox_to_anchor=(1.15, 1.0))
plt.show()

# Post-Test Data
POST = pd.read_csv("./Post Data_Long Form.csv")
print(POST.head())

POST['Participant'] = POST['Participant'].astype('category')
POST['target_nom'] = POST['Target.Time'].astype('category')
POST = POST[POST['Absolute.Error'] < 1000]

# Subsetting into retention and transfer
RET = POST[POST['Target.Time'].isin([1500, 1700, 1900])]

# Retention Data
g = sns.FacetGrid(data=RET, col='Group', sharey=False)
g.map_dataframe(sns.scatterplot, x='target_nom', y='Absolute.Error', hue='target_nom', palette='Set1', marker='o', dodge=True, jitter=True, alpha=0.4)
g.map_dataframe(sns.boxplot, x='target_nom', y='Absolute.Error', hue='target_nom', palette='Set1', dodge=True, width=0.8, showfliers=False, alpha=0.4)
g.set_axis_labels("Target (ms)", "Absolute Error")
g.set_titles("Group {col_name}")
g.set(ylim=(0, 1200))
g.add_legend(title="Target (ms)", loc='upper right', bbox_to_anchor=(1.15, 1.0))
plt.show()

g = sns.FacetGrid(data=RET, col='Group', sharey=False)
g.map(sns.kdeplot, 'Target.Time+Constant.Error', hue='target_nom', fill=True, common_norm=False, palette='Set1', alpha=0.4)
g.set_axis_labels("Time Produced (ms)", "Density")
g.set_titles("Group {col_name}")
g.set(ylim=(0, 0.003))
g.add_legend(title="Target (ms)", loc='upper right', bbox_to_anchor=(1.15, 1.0))
plt.show()

# Longitudinal Plots of Practice Data
ACQ_AVE = ACQ.groupby(['subID', 'group', 'block']).agg({
    'constant_error': 'mean',
    'absolute_error': 'mean'
}).reset_index()
ACQ_GROUP_AVE = ACQ_AVE.groupby(['group', 'block']).agg({
    'constant_error': ['mean', 'std'],
    'absolute_error': ['mean', 'std'],
    'subID': 'count'
}).reset_index()
ACQ_GROUP_AVE.columns = ['group', 'block', 'CE', 'CE_sd', 'AE', 'AE_sd', 'N']

g = sns.FacetGrid(data=ACQ_GROUP_AVE, col='group', sharey=False)
g.map(sns.lineplot, 'block', 'AE', palette='Set1')
g.map(sns.barplot, 'block', 'AE', hue='group', palette='Set1', errcolor='k', ci="sd")
g.set_axis_labels("Block", "Absolute Error (ms)")
g.set_titles("Group {col_name}")
g.set(ylim=(0, 250))
g.add_legend(title="Group", loc='upper right', bbox_to_anchor=(1.15, 1.0))
plt.show()

g = sns.FacetGrid(data=ACQ, col='target', sharey=False)
g.map_dataframe(sns.lineplot, x='trial_total', y='absolute_error', hue='group', palette='Set1', marker='o', lw=1)
g.set_axis_labels("Trial", "Absolute Error (ms)")
g.set(ylim=(0, 250))
g.add_legend(title="Group", loc='upper right', bbox_to_anchor=(1.15, 1.0))
plt.show()

g = sns.FacetGrid(data=ACQ, col='group', row='target', sharey=False)
g.map_dataframe(sns.scatterplot, x='trial_total', y='absolute_error', hue='group', palette='Set1', marker='o', size=1, alpha=0.3)
g.map_dataframe(sns.lineplot, x='trial_total', y='absolute_error', hue='group', palette='Set1', lw=1)
g.set_axis_labels("Trial", "Absolute Error (ms)")
g.set(ylim=(0, 250))
g.add_legend(title="Group", loc='upper right', bbox_to_anchor=(1.15, 1.0))
plt.show()
