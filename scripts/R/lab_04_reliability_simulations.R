library(tidyverse) # data formatting and graphing tools

pop <- runif(10000, min=1, max=20)

k = 1000
n = 10


means <- NULL
sds <- NULL
count <- NULL

for (i in 1:k){
  samp <- sample(pop, n, replace=TRUE)
  
  means[i] <- mean(samp)
  sds[i] <- sd(samp)
  count[i] <- length(samp)
}

SIMS <- data.frame(means, sds, count)

ggplot(SIMS) +
  geom_histogram(aes(x=means), col="black", fill="#56B4E9")+
  scale_x_continuous(name="Distribution of Sample Means", limits=c(0, 20))


# ------------------------------------------------------------------------------


x <- c(seq(from=0, to=2*pi, by=0.1))
y <- 2*sin(x)

DAT <- data.frame(x, y)

var(y)

plot(x=DAT$x, y=DAT$y)

# OR
ggplot(data=DAT, aes(x=x, y=y)) +
  geom_point()+
  geom_line()+
  scale_x_continuous(name="X Variable")+
  scale_y_continuous(name="Y Variable")

set.seed(10)
e1 <- rnorm(length(x), mean=0, sd=1)
y1 <- 2*sin(x)+e1

e2 <- rnorm(length(x), mean=0, sd=1)
y2 <- 2*sin(x)+e2


DAT2 <- data.frame(x, y1, y2)
head(DAT2)

# something like...
DAT2 %>% 
  rowwise %>%
  mutate(mean_y= mean(c(y1, y2)))

# or...
DAT2[,c("y1", "y2")]
rowMeans(DAT2[,c("y1", "y2")])


# Looping through:
DAT2$mean_y <- rowMeans(DAT2[,c("y1", "y2")])
head(DAT2)

my_list <- colnames(DAT2)[-1]
print(my_list)

iter <- NULL
ace <- NULL
rmse <- NULL

for (i in my_list){
  print(i)
  
  y_hat <- 2*sin(DAT2$x)
  iter[i] <- eval(i)
  ace[i] <- sum(DAT2[, i] - y_hat)/length(y_hat)
  rmse[i] <- sqrt(sum((DAT2[, i] - y_hat)^2)/length(y_hat))
}

SIM_DAT <- data.frame(iter, ace, rmse)
SIM_DAT


head(DAT2)
DAT2_LONG <- DAT2 %>% pivot_longer(cols=y1:mean_y, names_to = "iteration", values_to = "y_val") %>%
  arrange(iteration, x)

# Create a colorblind friendly palatte for plotting:
cbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

ggplot(data=DAT2_LONG, aes(x=x, y=y_val)) +
  geom_point(aes(col=iteration))+
  geom_line(aes(col=iteration))+
  scale_x_continuous(name="X Variable")+
  scale_y_continuous(name="Y Variable")+
  scale_color_manual(values=c(cbPalette))+
  theme(axis.text=element_text(size=10, color="black"), 
        axis.title=element_text(size=10, face="bold"),
        plot.title=element_text(size=10, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=10, face="bold"),
        legend.title = element_text(size=10, face="bold"),
        legend.text = element_text(size=10),
        legend.position = "bottom")
