# Task 1
num1 <- 15
num2 <- 7

sum_result <- num1 + num2
diff_result <- num1 - num2
prod_result <- num1 * num2
quotient_result <- num1 / num2

print("Task 1 Results:")
print(paste("Sum:", sum_result))
print(paste("Difference:", diff_result))
print(paste("Product:", prod_result))
print(paste("Quotient:", quotient_result))


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
print("\nTask 4 Results:")
for (i in 1:10) {
  square <- i^2
  print(paste(i, ":", square))
}



# Task 5
calculate_area <- function(length, width) {
  area <- length * width
  return(area)
}

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


student_names <- c("Alice", "Bob", "Charlie", "David", "Eva", "Frank", "Grace", "Hannah", "Ivan")
grades <- c("Freshman", "Sophomore", "Junior")
scores <- sample(60:100, 9 * length(grades), replace = TRUE)

students <- data.frame(
  name = rep(student_names, length(grades)),
  grade = rep(grades, each = length(student_names)),
  score = scores
)


average_scores <- tapply(students$score, students$grade, mean)
print(average_scores)


