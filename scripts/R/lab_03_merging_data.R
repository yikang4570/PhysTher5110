library(tidyverse) # data formatting and graphing tools


# 1.0. Importing, merging, and relabeling, the data. 
getwd()
setwd("C:/Users/kang.yi/Documents/GitHub/PhysTher5110/")
list.files()

list.files("./data")
list.files("./data/EEG_sub_files/")

setwd("./data/EEG_sub_files/")
getwd()

# Q2 Write a basic for loop that loops through the names of all the files and prints each name to the screen
file_list <- list.files()

# Loop through and print each file name
for (file_name in file_list) {
  print(file_name)
}

# could also write as 
# for (banana in file_list) {
# print(banana) 
# } 
# file_name is a temporary place holder 


# Testing out importing data with 1 subject:
test <- read.csv("./oa01_ec.csv",
                    header=TRUE, 
                    stringsAsFactors = TRUE)

head(test)

file_names <- list.files()
file_names
file_names[1]
file_names[7]

# Whether this is ture or not
file_names[1] == "oa01_ec.csv"


# A basic for-loop:
for(i in seq(1:10)) {
  print(i)
}

for(name in file_names) {
  print(name)
}


k = 0
for(file in file_names) {
    k = k+1
    print(file)
    print(k)
}



# Reading in the individual subjects and merging into a master file
if(1>=2){
  "Oh yeah!"
}
# Evaluates to true, returns Oh yeah!

file_names[1]
if(file_names[1]=="oa01_ec.csv"){
  "Oh yeah!"
}
# Evaluates to true, returns Oh yeah!

if(file_names[1]=="OA01_ec.csv"){
  "Oh yeah!"
}
# Evaluates to false, returns nothing


if(file_names[1]=="OA01_ec.csv"){
  "Oh yeah!"
} else {"Oh No!"}
# Evaluates to false, returns Oh No!
# the capitalization issue 

# Putting an if else statement inside of our for-lopp
for(name in file_names) { # loop through each files 
  print(name) # print the current name
  subject <- read.csv(name, #reas CSV into a data frame called subject
                      header=TRUE, #use the 1st row as column headers
                      stringsAsFactors = TRUE) # Convert character (free categories) columns to factors
  
  if (!exists("MASTER")){ #  # If the 'MASTER' data frame doesn't exist yet (i.e., first file)
    MASTER <- data.frame(subject)  # Create 'MASTER' using the first file's data
    MASTER$file_id <- name  # Add a new column 'file_id' to track which file the data came from
    
    
  } else { # otherwise
    temp_dataset <- data.frame(subject)  # For subsequent files, create a temporary data frame
    temp_dataset$file_id <-  name   # Add the 'file_id' column to the temporary dataset
    
    MASTER<-rbind(MASTER, temp_dataset) # Append the temporary dataset to 'MASTER'
    
    rm(temp_dataset) # Remove the temporary dataset to free up memory
  }
}


head(MASTER) # print the merged dataset
#This loop builds a single combined data frame (MASTER) from multiple CSV files, tagging each row with the source file name.

# move the file ID and Hz columns to the front of the dataset
MASTER <- MASTER %>% relocate(file_id)
MASTER <- MASTER %>% select(-X)

head(MASTER)

#Q6What class of variable is “file_id”? Include your code and the class it returns. 
class(MASTER$file_id)


# Break the file id into subject name and the condition
str_split(MASTER$file_id, "_")[[1]]

MASTER$subID <- factor(map_chr(str_split(MASTER$file_id, "_"), 1)) # # extract the first part and convert to the categorical variable 
MASTER$condition <- factor(map_chr(str_split(MASTER$file_id, "_"), 2))

## break down 
map_chr(str_split(MASTER$file_id, "_"), 2)
str_sub(map_chr(str_split(MASTER$file_id, "_"), 2), 1,2)
MASTER$condition <- factor(str_sub(map_chr(str_split(MASTER$file_id, "_"), 2), 1,2))
head(MASTER)

#AGE group
MASTER$age_group <- factor(str_sub(MASTER$subID, 1, 2))
#extracts the first two characters of each subject ID.
#str_sub(string, start, end)

## Reloaction
MASTER <- MASTER %>% relocate(file_id, subID, condition, age_group)
head(MASTER)

# Export the cleaned PSD data
getwd()
write.csv(MASTER, "MASTER_EO_and_EC_EEG.csv")




