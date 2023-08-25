cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

x <- rnorm(100, mean=50, 15)

hist(x)
mean(x)

value <- NULL
SS <- NULL
k=0
for (i in seq(from=1, to=100, by=10)) {
  k = k+1
  print(i)

  value[k] = i
  SS[k] = sum((x-i)^2)
}

DATA<-data.frame(value, SS)

plot(y=SS, x=value, data=DATA, col="red", type="b",
     xlab="Test Value", ylab="Sum of Squared Errors")

x <- c(seq(from=0, to=4*pi, by=0.1))
y1 <- sin(x)
y2 <- 2*sin(x)
y3 <- sin(x)+1
y4 <- sin(2*x)
y5 <- sin(x+1)

plot(y=y1, x=x, col="black", type="l", xlim=c(0,12),ylim=c(-2,2), ylab="Goal Movement")

plot(y=y1, x=x, col="black", type="l", xlim=c(0,12),ylim=c(-2,2), ylab="Goal Movement", main="Amplitude Change")
lines(y=y2, x=x, col="#E69F00", type="l", lwd=2)

plot(y=y1, x=x, col="black", type="l", xlim=c(0,12),ylim=c(-2,2), ylab="Goal Movement", main="Vertical Shift")
lines(y=y3, x=x, col="#56B4E9", type="l", lwd=2)

plot(y=y1, x=x, col="black", type="l", xlim=c(0,12),ylim=c(-2,2), ylab="Goal Movement", main="Period Change")
lines(y=y4, x=x, col="#D55E00", type="l", lwd=2)

plot(y=y1, x=x, col="black", type="l", xlim=c(0,12),ylim=c(-2,2), ylab="Goal Movement", main="Phase Shift")
lines(y=y5, x=x, col="#009E73", type="l", lwd=2)
