# Task 1
num1 <- 15
num1 # print the assigned vector
num2 <- 7

sum_result <- num1 + num2
diff_result <- num1 - num2
prod_result <- num1 * num2
quotient_result <- num1 / num2

print("Task 1 Results:")
print(paste("Sum:", sum_result)) # paste() function is used to combine text and values into a single string.
print(paste("Difference:", diff_result))
print(paste("Product:", prod_result))
print(paste("Quotient:", quotient_result))

##Another way to present the results in a table:
# Create a results table
task1_results <- data.frame(
  Operation = c("Sum", "Difference", "Product", "Quotient"),
  Value = c(sum_result, diff_result, prod_result, quotient_result)
)

# Print table
print("Task 1 Results:")
print(task1_results)


# Task 2
ages <- c(25, 30, 22, 40, 28)

average_age <- mean(ages)
updated_ages <- ages + 5

print("\nTask 2 Results:")
print(paste("Average Age:", average_age))
print("Updated Ages:")
print(updated_ages)


# Task 3
temperature <- 28

if (temperature > 25) {
  print("It's a hot day!")
} else {
  print("It's a pleasant day!")
}



# Task 4
print("\nTask 4 Results:") # start printing on the next line
for (i in 1:10) {
  square <- i^2
  print(paste(i, ":", square))
}
#1:10
#seq(1:10)
#seq(1:10:2) by setting up the space

#While loop - need to have an end
var=1
while (var<=10){
  square <- var^2
  print(paste(var, ":", square))
  var = var + 1 # tell the function to stop
}


# Task 5
calculate_area <- function(length, width) {
  area <- length * width
  return(area)
} # define the functions

love <- function (a,b){length <-a*b
return (length)}
x=10
y=20
love_length <- love(x,y)
love_length

rectangle_length <- 8
rectangle_width <- 5

area_result <- calculate_area(rectangle_length, rectangle_width)

print("\nTask 5 Results:")
print(paste("Area of Rectangle:", area_result))


# Task 6
students <- data.frame(
  name = character(0),
  grade = integer(0),
  score = numeric(0)
)
 # set up an empty frame work
# 0 --> empty vector of length 0.

student_names <- c("Alice", "Bob", "Charlie", "David", "Eva", "Frank", "Grace", "Hannah", "Ivan")
grades <- c("Freshman", "Sophomore", "Junior")
scores <- sample(60:100, 9 * length(grades), replace = TRUE) # 9 = 9 people
#sample() function picks random values from the given set (here: 60–100).
#length(grades) gives the number of elements in the vector grades.
#Multiplying by 9 tells R how many total random scores to generate.
#Example: if grades has 3 elements, then 9 * length(grades) = 27, so you’ll get 27 random scores
# you don’t run out of numbers

students <- data.frame(
  name = rep(student_names, length(grades)),
  grade = rep(grades, each = length(student_names)),
  score = scores
) 

average_scores <- tapply(students$score, students$grade, mean)
print(average_scores)

#Task 7 - Open question
#13
set.seed(1204)
grades <- c(9, 10, 11) # Define grade levels
n_students <- 10 # Number of students per grade
student_names <- paste0("Student", 1:n_students) # Simulate student names

# build up an empty dataset
students <- data.frame(
  name = character(0),
  grade = integer(0),
  arithmetic_score = numeric(0),
  algebra_score = numeric(0)
)

#generate the normalized scores
ari_scores <- pmin(as.integer(rnorm(n_students, mean = 75, sd = 10)),100)
alg_scores <- pmin(as.integer(rnorm(n_students, 64, 10)), 100)
#use of pmax /pmin to set up a ceiling limit
#ari_scores <- pmax(pmin(ari_scores, 100), 0)

#Update the data frame
students <- data.frame(
  name = rep(student_names, length(grades)),
  grade = rep(grades, each = length(student_names)),
  ari_scores = ari_scores,
  alg_scores = alg_scores
) 
students

#Plot the variables
#14
# Plot arithmetic scores
plot(students$grade, students$ari_scores, col = "blue", pch = 17,
     ylim = c(60, 100), xlab = "Grade", ylab = "Test Score",
     main = "Arithmetic vs Algebra Scores by Grade")

# Add algebra scores
points(students$grade, students$alg_scores, col = "red", pch = 3)

# Add legend
legend("right",
       legend = c("Arithmetic", "Algebra"),
       inset = c(0.09,0),
       col = c("blue", "red"),
       pch = c(17, 3),
       pt.cex = 0.7,     # smaller symbol size
       cex = 0.8,        # smaller text size 
       lty = 0)          # no line in legend

#bonus question
noise <- rnorm(n_students, -2, 4)
alg_scores <- students$ari_scores*0.8 + noise

plot(students$ari_scores, alg_scores, col = "blue", pch = 17,
     ylim = c(40, 100), xlab = "ari_scores", ylab = "alg_scores",
     main = "Correlation between two scores")


