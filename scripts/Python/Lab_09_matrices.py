import numpy as np
import pandas as pd

# 1a. Element-wise multiplication without loops
dat = np.array([[16, 2, 3, 13],
                [5, 11, 10, 8],
                [9, 7, 6, 12],
                [4, 14, 15, 1]])
print(dat)

vect = np.array([1, 2, 3, 4])

print(vect)

# Row-wise multiplication
rowMultiplier = dat * vect[:, np.newaxis]

# Column-wise multiplication
colMultiplier = dat * vect

print("Row-wise multiplication:")
print(rowMultiplier)

print("\nColumn-wise multiplication:")
print(colMultiplier)

# 1b. Vectorized alternative to replace loops
data = -2 + 2 * np.random.rand(10000, 20000)

# loop based approach
for i in range(10000):
    for j in range(20000):
        if data[i, j] > 1:
            data[i, j] = 0

# Vectorized replacement of values greater than 1 with 0
data[data > 1] = 0

data.max()
data.min()

# 1c. Finding the maximum value without loops
x = np.arange(1, 8)
y = np.arange(1, 6)

X = np.tile(x, (len(y), 1))
Y = np.tile(y[:, np.newaxis], (1, len(x)))

maxVal = np.max(np.max(np.sin(X) * np.cos(Y)))
print(maxVal)

# Finding the location of the maximum value
max_indices = np.unravel_index(np.argmax(np.sin(X) * np.cos(Y)), (len(y), len(x)))
print(f"The biggest element in XY is {maxVal} at XY{max_indices}")

# Note: In Python, we use NumPy for element-wise operations and SciPy for more advanced matrix operations.
