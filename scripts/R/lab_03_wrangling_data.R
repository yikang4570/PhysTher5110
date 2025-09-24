library(tidyverse) # data formatting and graphing tools


# 2.0. Wrangling Data 
# setwd("~/Instrumentation/")
setwd("/Users/yikang/Documents/GitHub/PhysTher5110/data")
list.files()
#list.files("./data/")

DATA <- read.csv("MASTER_EO_and_EC_EEG.csv",
                    header=TRUE, 
                    stringsAsFactors = TRUE) #character vectors (text data, or "strings") within a data structure, like a data frame, should be automatically converted into factors

# selecting specific columns
head(DATA)
DATA %>% select(subID, condition, Hz, Fz)
select(.data=DATA, subID, condition, Hz, Fz)

DATA %>% select(subID:F3)

DATA %>% select(-X) # drop column X 

DAT2 <- DATA %>% select(-X, -file_id)
head(DAT2)

# filtering specific rows
head(DAT2)
?dplyr::filter
DAT3 <- DAT2 %>% filter(subID=="oa01")

DAT3<- DAT2 %>% filter(subID=="oa01" | subID=="oa02") # OR

DAT3 <- DAT2 %>% filter(subID=="oa01" & Hz==0.997)
DAT3

summary(unique(DAT2$Hz))
hist(unique(DAT2$Hz))

DAT3 <- DAT2 %>% filter(Hz<=30)
summary(unique(DAT3$Hz))
hist(unique(DAT3$Hz))


# computing new variables
head(DAT3)

DAT3$Frontal <- (DAT3$F3 + DAT3$F7 + DAT3$Fz + DAT3$F4 + DAT3$F8)/5

?dplyr::mutate() # new column 
?dplyr::transmute() # include specific calculation 

?dplyr::rowwise # compute in a row
DAT3 <- DAT3 %>% rowwise %>%
  mutate(frontal = mean(c(F3, F7, Fz, F4, F8), na.rm=TRUE),
         central = mean(c(C3, Cz, C4), na.rm=TRUE),
         parietal = mean(c(P3, P7, Pz, P4, P8), na.rm=TRUE),
         occipital = mean(c(O1, Oz, O2), na.rm=TRUE)
  )

head(DAT3)
plot(DAT3$Frontal, DAT3$frontal)
cor(DAT3$Frontal, DAT3$frontal, use = "complete.obs")


# Selecting only the columns we want
head(DAT3)
DAT4 <- DAT3 %>% select(subID, condition, Hz,
                        frontal, central, parietal, occipital) %>%
  mutate(ln_Hz = log(Hz),
         ln_frontal = log(frontal),
         ln_central = log(central),
         ln_parietal = log(parietal),
         ln_occipital = log(occipital))

head(DAT4)

setwd("~/GitHub/ReproRehab/data/")
write.csv(DAT4, "data_PROCESSED_EEG.csv")

#ln_power ~ ln_hz plot 
plot(DAT4$ln_frontal, DAT4$ln_Hz)
plot(DAT4$ln_central, DAT4$ln_Hz)
plot(DAT4$ln_parietal, DAT4$ln_Hz)
plot(DAT4$ln_occipital, DAT4$ln_Hz)

library(dplyr)
library(ggplot2)
#plot - strategy 2
DAT4_long <- DAT4 %>%
  pivot_longer(
    cols = c(ln_frontal, ln_central, ln_parietal, ln_occipital),
    names_to = "region",
    names_prefix = "ln_",
    values_to = "log_power"
  ) %>%
  mutate(
    # Clean up the region names for better plotting
    region = tools::toTitleCase(region) # capitalize the first word
  )

cat("\n--- Generating combined plot for all frequencies ---\n")

plot_all_freq <- ggplot(DAT4_long, aes(x = ln_Hz, y = log_power)) +
  geom_point(alpha = 0.5, color = "#2c7bb6") +
  geom_smooth(method = "lm", se = FALSE, color = "#d7191c", linetype = "dashed") +
  facet_wrap(~ region, scales = "free_y") + # 'scales = "free_y"' allows each panel to have its own Y-axis range
  labs(
    title = "Log-transformed Power vs. Frequency by Brain Region (All Frequencies)",
    x = "Log-transformed Frequency (Hz)",
    y = "Log-transformed Power"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    strip.background = element_rect(fill = "grey90", color = NA),
    strip.text = element_text(face = "bold")
  )

# Print the plot
print(plot_all_freq)