library(tidyverse)

setwd("~/GitHub/PhysTher5110/")
list.files("./data/gait_example_data")

RAW_DAT <- read.csv("./data/gait_example_data/DDH25_0Run01.csv", header=FALSE,
                    sep=c(","), na.strings=c(" ", ""))


# Reshaping/labeling the FORCE data --------------------------------------------
RAW_DAT <- read.csv("./data/gait_example_data/DDH25_0Run01.csv", header=FALSE,
                    sep=c(","), na.strings=c(" ", ""))

FORCE_DAT <- RAW_DAT[6:9795,]
head(FORCE_DAT)

FORCE_LABS <- RAW_DAT[3:4,]
FORCE_LABS

FORCE_LABS <- data.frame(t(FORCE_LABS))
FORCE_LABS

colnames(FORCE_LABS) <- c("level1", "level2")

FORCE_LABS <- FORCE_LABS %>% 
  fill(level1, .direction="down")
FORCE_LABS

FORCE_LABS$level3 <- paste(FORCE_LABS$level1,
                           FORCE_LABS$level2,
                           sep="_")

colnames(FORCE_DAT) <- FORCE_LABS$level3
FORCE_DAT

write.csv(FORCE_DAT, "./data/gait_example_data/force_data.csv")


# Reshaping/labeling the MOTION data -------------------------------------------
RAW_DAT <- read.csv("./data/gait_example_data/DDH25_0Run01.csv", header=FALSE,
                    sep=c(","), na.strings=c(" ", ""),
                    skip=9798)
head(RAW_DAT)
MOTION_DAT <- RAW_DAT[4:nrow(RAW_DAT),]
head(MOTION_DAT)


MOTION_LABS <- RAW_DAT[1:2,]
MOTION_LABS

MOTION_LABS <- data.frame(t(MOTION_LABS))
MOTION_LABS

colnames(MOTION_LABS) <- c("level1", "level2")

MOTION_LABS <- MOTION_LABS %>% 
  fill(level1, .direction="down")
MOTION_LABS

MOTION_LABS$level3 <- paste(MOTION_LABS$level1,
                            MOTION_LABS$level2,
                           sep="_")

colnames(MOTION_DAT) <- MOTION_LABS$level3
MOTION_DAT

write.csv(MOTION_DAT, "./data/gait_example_data/motion_data.csv")


# Selecting and renaming only the variables we want ----------------------------
head(FORCE_DAT)
FORCE_DAT <- FORCE_DAT %>% select(`Treadmill Left - Force_Fx`,
                     `Treadmill Left - Force_Fy`, 
                     `Treadmill Left - CoP_Cx`, 
                     `Treadmill Left - CoP_Cy`) %>%
  rename(force_x = `Treadmill Left - Force_Fx`,
         force_y = `Treadmill Left - Force_Fy`, 
         cop_x = `Treadmill Left - CoP_Cx`, 
         cop_y = `Treadmill Left - CoP_Cy`) %>%
  rownames_to_column(var="sample")

plot(FORCE_DAT$force_y)
plot(FORCE_DAT$force_x)
plot(FORCE_DAT$cop_y)
plot(FORCE_DAT$cop_x)


head(MOTION_DAT)
MOTION_DAT <- MOTION_DAT %>% select(`DDH25:RICAL_X`, `DDH25:RICAL_Y`,
                      `DDH25:LICAL_X`, `DDH25:LICAL_Y`) %>%
  rename(right_heel_x = `DDH25:RICAL_X`, 
         right_heel_y = `DDH25:RICAL_Y`,
         left_heel_x = `DDH25:LICAL_X`, 
         left_heel_y = `DDH25:LICAL_Y`) %>%
  rownames_to_column(var="sample")

plot(MOTION_DAT$right_heel_x)
plot(MOTION_DAT$right_heel_y)
plot(MOTION_DAT$left_heel_x)
plot(MOTION_DAT$left_heel_y)


# Down sampling the data to align FORCE and MOTION -----------------------------