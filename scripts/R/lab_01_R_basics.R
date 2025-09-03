#Yi Kang 
#09/03/25

# assigning values to and basic functions ----
x = 2 # this is a comment
x = x + 3 

x*3


y = 2 

x/y


z = "word"

x*z

x < 2
x > 2

z < 2
z > 2
# 2 gets coerced to a string, and then strings are compared in ASCII order
# "." < 0 < 2 < ...9 < A < B < C <... W...

is.character(z)
is.numeric(z)

# some data types ----
# vectors
x <- 2 # vector of length one
x <- c(2, 3, 4) # vector of length 3
x
y
x*y # the smaller vector is repeated to match the larger vector

y <- c(0, 1, 0) # item-wise operations for vectors of the same length
x
y
x*y

z <- c("red", "red", "blue", "blue", "green", "green")
summary(z)
str(z)

z <- factor(z)
summary(z)
str(z)


# matrix 
mat_data <- c(1,2,3,4,5,6,7,8,9)
mat_data
mat1 <- matrix(data=mat_data, nrow=3, ncol=3)
mat1


mat1[1,]
mat1[,3]
mat1[1,3]

# lists
# are very flexible, data do not need to be the same length or the same type
my_list <- list("a" = 2.5, "b" = TRUE, "c" = 91:87)
my_list

my_list$a
my_list$c
my_list$c[3]


# data frames
sex <- factor(c(rep("male", 10), rep("female", 10)))
height <- c(rnorm(10, mean=67, sd=2.5), rnorm(10, 64, 2.2))

DAT1 <- data.frame(sex, height)
DAT1

plot(height~sex, data=DAT1)



# thinking more about functions and arguments ----
x
summary(x)
?summary()

class(x)
class(z)
class(my_list)
class(DAT1)

str(my_list)
str(DAT1)


mean(x)
x<-append(x, c(NA, 0, 15))
x
mean(x)
mean(x, na.rm=TRUE)


# installing and loading packages -----
install.packages("tidyverse")
library("tidyverse")


# setting the working directory -----
getwd()
list.files()

setwd()

# you can also set the working directory manually through "Session"



# importing data from your computer ----
setwd("~/GitHub/ReproRehab/")
list.files()
list.files("./data/")

DAT2 <- read.csv("./data/data_PROCESSED_EEG.csv",
                 header=TRUE, 
                 stringsAsFactors = TRUE)
head(DAT2)




# importing data from the web
DAT3 <- read.csv("https://raw.githubusercontent.com/keithlohse/grad_stats/main/data/data_THERAPY.csv",
                 header=TRUE,
                 stringsAsFactors = TRUE)

DAT3

# a simple for-loop
for(i in seq(1:3)){
  print("Hello!")
}


# In class assignment ----------------------------------------------------------------
#2. Create a vector A that has four values 1, 1, 1, 1. 
## 2. Create A = c(1,1,1,1)
A <- rep(1, 4) ##additional way to assign the vector
A
A <- c(1,1,1,1)
A

## 3. Create a vector B that have two values 2, 3.
B <- c(2, 3)
B

## 4. Multiply vectors A and B together. What is the result? 
A_times_B <- A*B
A_times_B
# [1] 2 3 2 3 # Recycling rule applies: result length is 4

## 5. Write a for-loop that counts from 1 to 10 and outputs the current value at every step. 
for (i in 1:10) {
  print(i)
}

## 6. Write a for-loop that counts from 1 to 10 and outputs the sum of all previous values up to that point at every step.
running_sum <- 0
for (i in 1:10) {
  running_sum <- running_sum + i
  print(running_sum)
}

#We can also use 
#for (i in seq(1:10)){
#running_sum <- running_sum + i
#print(running_sum)
#}

## 7. Create a data frame with 40 simulated participants, 20 males and 20 females. Simulate normally distributed heights for each of these groups using the values given in the Lab 01 script file. How can you most efficiently calculate the mean and the standard deviation for the males and females? (Hint. We did not directly show you how to do this. This will mostly be an exercise in creative thinking, searching the web, and working together!)
set.seed(1204)  # for reproducibility
#generate simulated data
sex <- factor(c(rep("male", 20), rep("female", 20))) #rep=repeat
height <- c(rnorm(20, mean=67, sd=2.5), rnorm(20, 64, 2.2)) #number of observation, mean, sd

DAT1 <- data.frame(sex, height)
DAT1

plot(height~sex, data=DAT1)

#given the dataset DAT1, calculate the mean (sd) for male and female 
#option 1
library(dplyr)
a<- DAT1 %>%
  group_by(sex) %>%
  summarise(
    mean_height = mean(height),
    sd_height   = sd(height),
    .groups = "drop"
  )
a

# option 2
tapply(DAT1$height, DAT1$sex, mean) #tapply(X, INDEX/factor, FUN)
tapply(DAT1$height, DAT1$sex, sd) #Apply a function to subsets of a vector, defined by one or more factor(s) (grouping variables).
#different apply function
# Purpose: Apply a function to each element of a list or vector and simplify the result into a vector or matrix if possible.
# sapply(list(1:5, 6:10), mean) - Apply a function across a set of elements without grouping.

#option 3
mean(DAT1$height[DAT1$sex == "male"]) # [] = filter 
sd(DAT1$height[DAT1$sex == "male"])

# 8. Create a plot that shows height as a function of sex for your 40 simulated participants. Insert your plot in the document below. 

