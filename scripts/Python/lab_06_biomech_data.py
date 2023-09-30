import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Set the working directory (if needed)
import os
os.chdir("C:/Users/kelop/OneDrive/Documents/GitHub/PhysTher5110/")
os.listdir()

# # Read the raw data
# raw_dat = pd.read_csv("./data/gait_example_data/DDH25_0Run01.csv", sep=",",
# header=None)
# 
# # Reshape and label the FORCE data
# force_dat = raw_dat.iloc[5:9794, :]
# force_labs = raw_dat.iloc[2:4, :].T
# force_labs.columns = ["level1", "level2"]
# force_labs['level1'].fillna(method='ffill', inplace=True)
# force_labs['level3'] = force_labs['level1'] + "_" + force_labs['level2']
# force_dat.columns = force_labs['level3']
# force_dat.to_csv("./data/gait_example_data/force_data.csv", index=False)
# 
# # Reshape and label the MOTION data
# motion_dat = raw_dat.iloc[3:, :]
# motion_labs = raw_dat.iloc[:2, :].T
# motion_labs.columns = ["level1", "level2"]
# motion_labs['level1'].fillna(method='ffill', inplace=True)
# motion_labs['level3'] = motion_labs['level1'] + "_" + motion_labs['level2']
# motion_dat.columns = motion_labs['level3']
# motion_dat.to_csv("./data/gait_example_data/motion_data.csv", index=False)
# 

# Select and rename variables
force_dat = pd.read_csv("./data/gait_example_data/force_data.csv", sep=",")

force_dat = force_dat[['Treadmill Left - Force_Fx', 'Treadmill Left - Force_Fy', 
                        'Treadmill Left - CoP_Cx', 'Treadmill Left - CoP_Cy']]
force_dat.columns = ['force_x', 'force_y', 'cop_x', 'cop_y']
force_dat['sample'] = force_dat.index


# Plot FORCE data
plt.figure(figsize=(10, 6))
plt.plot(force_dat['force_y'], linestyle='-', label='Force Y')
plt.plot(force_dat['force_x'], linestyle='-', label='Force X')
plt.plot(force_dat['cop_y'], linestyle='-', label='CoP Y')
plt.plot(force_dat['cop_x'], linestyle='-', label='CoP X')
plt.xlabel('Sample')
plt.ylabel('Value')
plt.legend(loc="best")
plt.show()

# Reshape and rename MOTION data
motion_dat = pd.read_csv("./data/gait_example_data/motion_data.csv", sep=",")

motion_dat = motion_dat[['DDH25:RICAL_X', 'DDH25:RICAL_Y', 'DDH25:LICAL_X', 'DDH25:LICAL_Y']]
motion_dat.columns = ['right_heel_x', 'right_heel_y', 'left_heel_x', 'left_heel_y']
motion_dat['sample'] = motion_dat.index



# Plot MOTION data
plt.figure(figsize=(10, 6))
plt.plot(motion_dat['right_heel_x'], linestyle='-', label='Right Heel X')
plt.plot(motion_dat['right_heel_y'], linestyle='-', label='Right Heel Y')
plt.plot(motion_dat['left_heel_x'], linestyle='-', label='Left Heel X')
plt.plot(motion_dat['left_heel_y'], linestyle='-', label='Left Heel Y')
plt.xlabel('Sample')
plt.ylabel('Value')
plt.legend(loc='best')
plt.show()

# Downsample the FORCE data
force_dat_ds = force_dat.iloc[::10, :]

# Check the number of rows in both datasets
print(len(force_dat_ds))
print(len(motion_dat))

# Merge the datasets
merged = pd.concat([motion_dat, force_dat_ds.iloc[:, :-1]], axis=1)
merged = merged.apply(pd.to_numeric, errors='ignore')

# Basic plots and summary statistics
print(merged['sample'].describe())
print(merged.info())

# Plotting heel positions and force
plt.figure(figsize=(10, 6))
plt.plot(merged['sample'], merged['right_heel_y'], label='Right Heel Y', linestyle='-')
plt.plot(merged['sample'], merged['left_heel_y'], label='Left Heel Y', linestyle='-')
plt.xlabel('Sample')
plt.ylabel('Heel Position')
plt.legend()
plt.show()

plt.figure(figsize=(10, 6))
plt.scatter(merged['left_heel_y'], merged['right_heel_y'], label='Left vs. Right Heel')
plt.xlabel('Left Heel Y')
plt.ylabel('Right Heel Y')
plt.legend()
plt.show()

plt.figure(figsize=(10, 6))
plt.plot(merged['right_heel_y'], merged['force_y'], linestyle='-', label='Force Y vs. Right Heel Y')
plt.xlabel('Right Heel Y')
plt.ylabel('Force Y')
plt.legend()
plt.show()
