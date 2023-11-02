# 1a. Element-wise multiplication without loops
dat <- matrix(c(16, 2, 3, 13,
                5, 11, 10, 8,
                9, 7, 6, 12,
                4, 14, 15, 1), nrow = 4, ncol = 4, byrow = TRUE)
dat

vect <- 1:4
vect

# Row-wise multiplication
rowMultiplier <- dat * vect

# Column-wise multiplication
colMultiplier <- t(t(dat) * vect)

cat("Row-wise multiplication:\n")
print(rowMultiplier)

cat("\nColumn-wise multiplication:\n")
print(colMultiplier)

# 1b. Vectorized alternative to replace loops
set.seed(123)  # Setting seed for reproducibility
data <- -2 + 2 * matrix(runif(10000 * 20000), nrow = 10000, ncol = 20000)

max(data)
min(data)

# loop-based solution
for (i in 1:10000) {
  for (j in 1:20000) {
    if (data[i, j] > 1) {
      data[i, j] <- 0
    }
  }
}

# Vectorized replacement of values greater than 1 with 0
data[data > 1] <- 0

# 1c. Finding the maximum value without loops
x <- 1:7
y <- 1:5

X <- matrix(rep(x, each = length(y)), nrow = length(y), ncol = length(x), byrow = TRUE)
Y <- matrix(rep(y, times = length(x)), nrow = length(y), ncol = length(x), byrow = TRUE)

X
Y

maxVal <- max(max(sin(X) * cos(Y)))

# Finding the location of the maximum value
max_indices <- which(sin(X) * cos(Y) == maxVal, arr.ind = TRUE)
max_indices

cat(paste("The biggest element in XY is", maxVal, "at XY(", max_indices[1], ",", max_indices[2], ")\n"))
