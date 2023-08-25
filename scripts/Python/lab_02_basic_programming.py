# Task 1
num1 = 15
num2 = 7

sum_result = num1 + num2
diff_result = num1 - num2
prod_result = num1 * num2
quotient_result = num1 / num2

print("Task 1 Results:")
print(f"Sum: {sum_result}")
print(f"Difference: {diff_result}")
print(f"Product: {prod_result}")
print(f"Quotient: {quotient_result}")


# Task 2
ages = [25, 30, 22, 40, 28]

average_age = sum(ages) / len(ages)
updated_ages = [age + 5 for age in ages]

print("\nTask 2 Results:")
print(f"Average Age: {average_age}")
print("Updated Ages:")
print(updated_ages)


# Task 3
temperature = 28

if temperature > 25:
    print("It's a hot day!")
else:
    print("It's a pleasant day!")


# Task 4
print("\nTask 4 Results:")
for i in range(1, 11):
    square = i ** 2
    print(f"{i}: {square}")


# Task 5
def calculate_area(length, width):
    area = length * width
    return area

rectangle_length = 8
rectangle_width = 5

area_result = calculate_area(rectangle_length, rectangle_width)

print("\nTask 5 Results:")
print(f"Area of Rectangle: {area_result}")


# Task 6
import pandas as pd
import numpy as np

students = pd.DataFrame({
    "name": np.array([]),
    "grade": np.array([]),
    "score": np.array([])
})

student_names = ["Alice", "Bob", "Charlie", "David", "Eva", "Frank", "Grace", "Hannah", "Ivan"]
grades = ["Freshman", "Sophomore", "Junior"]
scores = np.random.choice(range(60, 101), 9 * len(grades), replace=True)

students = pd.DataFrame({
    "name": np.repeat(student_names, len(grades)),
    "grade": np.tile(grades, len(student_names)),
    "score": scores
})

average_scores = students.groupby("grade")["score"].mean()
print(average_scores)
