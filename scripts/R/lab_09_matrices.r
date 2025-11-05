# 1a. Element-wise multiplication without loops
dat <- matrix(c(16, 2, 3, 13,
                5, 11, 10, 8,
                9, 7, 6, 12,
                4, 14, 15, 1), nrow = 4, ncol = 4, byrow = TRUE) #row by row not column by column
dat

vect <- 1:4 #vect <- c(1,2,3,4) #vect <- seq(1, 4, by = 1)
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

#no loop 
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

#-----PART 1------
#see above 

#-----PART 2------

#Question a
## arguments: q = c(theta1, theta2), L = c(L1, L2)
forwardkinematics <- function(q, L) {
  stopifnot(is.numeric(q), is.numeric(L),
            length(q) == 2, length(L) == 2)
  
  th1 <- q[1]; th2 <- q[2]
  L1  <- L[1]; L2  <- L[2]
  
  elbow <- c(L1 * cos(th1), L1 * sin(th1))
  hand  <- elbow + c(L2 * cos(th1 + th2), L2 * sin(th1 + th2))

  
## plot the configuration
  plot(NA, # set up an empty plot
       xlim = c(-sum(L), sum(L)), #set up x-axis range 
       ylim = c(-sum(L), sum(L)), #set up y-axis range
       xlab = "X (m)", ylab = "Y (m)", asp = 1,
       main = "2-link planar arm (relative angles)")
  grid() #background grid
  points(0, 0, pch = 19, cex = 1.1)                       # shoulder/ origin 
  segments(0, 0, elbow[1], elbow[2], lwd = 2)             # upper arm #draws a straight line between two pointst
  points(elbow[1], elbow[2], pch = 19, col = 4)           # elbow
  segments(elbow[1], elbow[2], hand[1], hand[2], lwd = 2) # forearm
  points(hand[1], hand[2], pch = 19, col = 2)             # hand
  legend("right", c("Hand","Elbow","Shoulder"),
         pch = c(19,19,19), col = c(2,4,1), bty = "n")
  
  ## return a named list 
  list(hand = hand, elbow = elbow)
}

q_test<-c(pi/4,pi/3)
L_test<-c(0.3, 0.32)

print(forwardkinematics(q = q_test, L = L_test))

#Question b
#for each link i: rotate about z by q[i], then translate along x by L[i]
# Rotational matrix 
Rz <- function(theta) {
  cth <- cos(theta); sth <- sin(theta)
  matrix(c(cth, -sth, 0, 0,
           sth,  cth, 0, 0,
           0,     0,  1, 0,
           0,     0,  0, 1), nrow = 4, byrow = TRUE)
}
# cos, sin = x axis rotation
# -sin, cos = y axis rotation

Tx <- function(L) {
  matrix(c(1, 0, 0, L, # no rotation in x, y, z; there's translation in L in x axis
           0, 1, 0, 0,
           0, 0, 1, 0,
           0, 0, 0, 1), nrow = 4, byrow = TRUE)
} # X-axis translation 

#End-effector position 
fkh <- function(L, q) {
  stopifnot(is.numeric(L), is.numeric(q), length(L) == length(q))
  H <- diag(4)
  for (i in seq_along(L)) H <- H %*% Rz(q[i]) %*% Tx(L[i])
  H
}

#Get all position in plotting
fk_positions <- function(L, q) {
  stopifnot(is.numeric(L), is.numeric(q), length(L) == length(q))
  H <- diag(4) #start from base and record (0,0)
  pts <- matrix(NA_real_, nrow = length(L) + 1, ncol = 2)
  pts[1, ] <- c(0, 0)  # base
  for (i in seq_along(L)) {
    H <- H %*% Rz(q[i]) %*% Tx(L[i]) #for each link, update
    p <- H %*% c(0, 0, 0, 1) #apply p0 to the homogeneous point | give me the location of this frame’s origin, after rotation and translation
    pts[i + 1, ] <- p[1:2] #extract the x and y coordinates from p and write into the next row 
    #pts[1,] = (0,0); pts[2,] = elbow position 
  }
  pts #return the matrix of joints coordinates 
}

# Replot of the 2a by using the 2a 
q1_b<-c(pi/4,pi/3)
L1_b<-c(0.3, 0.32)

pos_q1_b <- fk_positions(L1_b, q1_b)

plot_arm(pos_q1_b, add = FALSE, lty = 1, pch_joint = 19)
legend("right", legend = c("q1_b"),
       lty = c(1, 2), pch = c(19, 1), bty = "n")

## 4x4 end-effector pose matrices:
H_q1_b <- fkh(L1_b, q1_b)

#Question C
# Plot function
plot_arm <- function(pts, add = FALSE, lty = 1, pch_joint = 19, xlim = c(-1, 1), ylim = c(-1, 1)) {
  
  # If add = FALSE, start a fresh plot window
  if (!add) {
    plot(NA, xlim = xlim, ylim = ylim,
         xlab = "X (m)", ylab = "Y (m)", asp = 1,
         main = "3-link planar manipulator")
    grid()
  }
  
  # Draw arm links (lines between joints)
  lines(pts[,1], pts[,2], lwd = 2, lty = lty)
  
  # Draw joint markers
  points(pts[,1], pts[,2], pch = pch_joint)
}


#Plot 
L3 <- c(0.32, 0.30, 0.40)
q1 <- c(pi/4, pi/2,  -pi/3)
q2 <- c(2*pi/3,  -pi/4, pi/2)

pos_q1 <- fk_positions(L3, q1)
pos_q2 <- fk_positions(L3, q2)

plot_arm(pos_q1, add = FALSE, lty = 1, pch_joint = 19)
plot_arm(pos_q2, add = TRUE,  lty = 2, pch_joint = 1)
legend("right", legend = c("q1", "q2"),
       lty = c(1, 2), pch = c(19, 1), bty = "n")

## If you also need the 4x4 end-effector pose matrices:
H_q1 <- fkh(L3, q1)
H_q2 <- fkh(L3, q2)

