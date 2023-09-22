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
  rownames_to_column(var="sample") %>%
  mutate(sample = as.numeric(sample)-5) # To start the samples at 1

plot(FORCE_DAT$force_y, type="l")
plot(FORCE_DAT$force_x, type="l")
plot(FORCE_DAT$cop_y, type="l")
plot(FORCE_DAT$cop_x, type="l")


head(MOTION_DAT)
MOTION_DAT <- MOTION_DAT %>% select(`DDH25:RICAL_X`, `DDH25:RICAL_Y`,
                      `DDH25:LICAL_X`, `DDH25:LICAL_Y`) %>%
  rename(right_heel_x = `DDH25:RICAL_X`, 
         right_heel_y = `DDH25:RICAL_Y`,
         left_heel_x = `DDH25:LICAL_X`, 
         left_heel_y = `DDH25:LICAL_Y`) %>%
  rownames_to_column(var="sample") %>%
  mutate(sample = as.numeric(sample)-3) # To start the samples at 1

plot(MOTION_DAT$right_heel_x, type="l")
plot(MOTION_DAT$right_heel_y, type="l")
plot(MOTION_DAT$left_heel_x, type="l")
plot(MOTION_DAT$left_heel_y, type="l")


# Down sampling the data to align FORCE and MOTION -----------------------------
# Note that the force data is sampled at a much higher rate
# (2000 Hz) than the motion capture data (200 Hz).
# This leades to a much longer time series for the force data
# compared to the motion data.
# Therefore, in order to combine these two time series, we will
# need to DOWN SAMPLE the force data. One simple way we can do 
# this is by taking every tenth force observation:

FORCE_DAT_DS <- FORCE_DAT[c(seq(from=1, to=nrow(FORCE_DAT), by=10)),]


# The two datasets are now aligned in time and can be merged
# Rather than merge by a specific variable value (note that the two
# sample values do not align), we will simply bind the two sets 
# of columns together as they are the same length
nrow(FORCE_DAT_DS)
nrow(MOTION_DAT)

MERGED <- cbind(MOTION_DAT,
                FORCE_DAT_DS %>% select(-sample)) %>%
  mutate_at(c("right_heel_x", "right_heel_y", "left_heel_x",
              "left_heel_y", "force_x", "force_y", "cop_x", "cop_y"), 
            as.numeric)
head(MERGED)

# Basic plots of heel position and force ---------------------------------------
summary(MERGED$sample)
str(MERGED)
# Right heel Y over time
plot(x=MERGED$sample, y=MERGED$right_heel_y)
# Left heel Y over time
plot(x=MERGED$sample, y=MERGED$left_heel_y)
# Relationship between left and right heel
plot(x=MERGED$left_heel_y, y=MERGED$right_heel_y)
# Why does force look like a figure-8 compared to right heel?
plot(y=MERGED$force_y, x=MERGED$right_heel_y)


# Visualizing left and right heel position at the same time --------------------
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
               "#F0E442", "#0072B2", "#D55E00", "#CC79A7",
               "#999933", "#882255", "#661100", "#6699CC")

ggplot(data=MERGED, aes(x=sample)) +
  geom_point(aes(y=right_heel_y), shape=21, col=cbPalette[2])+
  geom_point(aes(y=left_heel_y), shape=21, col=cbPalette[3])+
  scale_y_continuous(name = "Heel Position") +
  scale_x_continuous(name = "Time (samples)")+
  theme_bw()+
  scale_fill_manual(values=cbPalette)+
  scale_colour_manual(values=cbPalette)+
  theme(axis.text=element_text(size=10, color="black"), 
        axis.title=element_text(size=10, face="bold"),
        plot.title=element_text(size=10, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=10, face="bold"),
        legend.title = element_text(size=10, face="bold"),
        legend.text = element_text(size=10),
        legend.position = "bottom")
  




