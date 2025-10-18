library(tidyverse)
library(RColorBrewer)
library(ggplot2)
# By treating this workshop as an R project, we can use relative file paths that
# allow you to open the data anywhere on any computer, provided you have downloaded 
# the whole workshop folder.

# Instrumentation Assignment ---------------------------------------------------
#Question 1
DATA1 <- read.csv("/Users/yikang/Documents/GitHub/PhysTher5110/data/data_overall_tendon_muscle.csv")
set.seed(1234)
DATA1 <- DATA1 %>%
  mutate(
    sex   = sample(c("F","M"), size = n(), replace = TRUE),
    group = sample(c("Treatment","Control"), size = n(), replace = TRUE)
  ) #generate F / M 
DATA1 
# Pick a colorblind-friendly palette
my_colors <- brewer.pal(3, "Set2")[1:2]

# Pick the continuous 
y_var <- "linMod" 
# --- Plot 1: Raw data with boxplots by sex ---
ggplot(DATA1, aes(x = sex, y = .data[[y_var]], fill = sex)) +
  geom_boxplot(color = "black", alpha = 0.3, width = 0.5, outlier.shape = NA) +
  geom_point(pch = 21, color = "black", size = 2, alpha = 0.8,
             position = position_jitter(width = 0.15, height = 0)) +
  scale_fill_manual(values = my_colors) +
  scale_x_discrete(name = "Sex", labels = c("Female", "Male")) +
  scale_y_continuous(name = "Linear Modulus (MPa)") +
  theme_bw(base_size = 14) +
  theme(
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5)
  ) +
  ggtitle("Linear Modulus by Sex in Mouse Model")

# Question 2
# panel 
ggplot(DATA1, aes(x = group, y = .data[[y_var]], fill = group)) +
  geom_boxplot(color = "black", alpha = 0.3, width = 0.5, outlier.shape = NA) +
  geom_point(pch = 21, color = "black", size = 2, alpha = 0.8,
             position = position_jitter(width = 0.15, height = 0)) +
  scale_fill_manual(values = my_colors) +
  scale_x_discrete(name = "Intervention") +
  scale_y_continuous(name = "Linear Modulus (MPa)") +
  facet_wrap(~ sex) +
  theme_bw(base_size = 14) +
  theme(
    axis.title  = element_text(face = "bold"),
    axis.text   = element_text(color = "black", size = 12),
    panel.grid.minor = element_blank(),
    strip.text  = element_text(size = 14, face = "bold"),
    legend.position = "none",
    plot.title  = element_text(face = "bold", size = 16, hjust = 0.5)
  ) +
  ggtitle("Linear Modulus by Treatment Group, Faceted by Sex")

#Question 3
# --- Choose colorblind-friendly palette ---
my_colors <- brewer.pal(3, "Dark2")[1:2]

x_var <- "peakStress"
y_var <- "percRelax"  

# --- Scatter plot with regression line ---
ggplot(DATA1, aes(x = .data[[x_var]], y = .data[[y_var]])) +
  geom_point(color = brewer.pal(3, "Dark2")[2], size = 3, alpha = 0.8) +
  geom_smooth(method = "lm", se = TRUE, color = brewer.pal(3, "Dark2")[1], lwd = 1.2) +
  scale_x_continuous(name = "Peak Stress (MPa)") +
  scale_y_continuous(name = "Percent Relaxation (%)") +
  theme_bw(base_size = 14) +
  theme(
    axis.title = element_text(face = "bold"),
    axis.text  = element_text(color = "black", size = 12),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5)
  ) +
  ggtitle("Relationship Between Peak Stress and Percent Relaxation")

#Question 4 
qs <- quantile(DATA1$peakStress, probs = c(0, .25, .5, .75, 1), na.rm = TRUE)
bin_labels <- paste0(
  sprintf("%.2f", qs[-length(qs)]), "–", sprintf("%.2f", qs[-1])
)

DATA1 <- DATA1 %>%
  mutate(
    peakStress_bin = cut(
      peakStress,
      breaks = qs,
      include.lowest = TRUE,
      labels = bin_labels
    )
  )

# --- Summarize outcome (percRelax) within bins ---
SUM <- DATA1 %>%
  group_by(peakStress_bin) %>%
  summarise(
    N   = sum(!is.na(percRelax)),
    mean_y = mean(percRelax, na.rm = TRUE),
    sd_y   = sd(percRelax, na.rm = TRUE),
    se_y   = sd_y / sqrt(N),
    ci95   = 1.96 * se_y,
    .groups = "drop"
  ) %>%
  # keep factors ordered from low to high
  mutate(peakStress_bin = factor(peakStress_bin, levels = bin_labels))

# --- Choose colorblind-friendly palette ---
col_points <- brewer.pal(3, "Dark2")[2]
col_error  <- brewer.pal(3, "Dark2")[1]

# --- Plot: mean ± 95% CI by peakStress quartile ---
ggplot(SUM, aes(x = peakStress_bin, y = mean_y)) +
  geom_point(size = 3, color = "black", fill = col_points, pch = 21) +
  geom_errorbar(aes(ymin = mean_y - ci95, ymax = mean_y + ci95),
                width = 0.15, size = 0.8, color = col_error) +
  # If you prefer SD instead of 95% CI, replace ci95 with sd_y above:
  # geom_errorbar(aes(ymin = mean_y - sd_y, ymax = mean_y + sd_y), ...)
  geom_line(aes(group = 1), color = "grey40", linewidth = 0.8) +
  labs(
    x = "Peak Stress (MPa) — Quartile Bins",
    y = "Percent Relaxation (%)",
    title = "Percent Relaxation by Peak Stress Quartiles (Mean ± 95% CI)"
  ) +
  theme_bw(base_size = 14) +
  theme(
    axis.title = element_text(face = "bold"),
    axis.text  = element_text(color = "black"),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", hjust = 0.5)
  )

#Q4 -2 
# --- Plot: raw data + mean ± 95% CI per quartile ---
dot_color <- brewer.pal(3, "Dark2")[2]
error_color <- brewer.pal(3, "Dark2")[1]

ggplot() +
  # raw dots
  geom_jitter(
    data = DATA1,
    aes(x = peakStress_bin, y = .data[[y_var]]),
    width = 0.15,
    alpha = 0.6,
    color = dot_color,
    size = 2
  ) +
  # mean ± 95% CI
  geom_point(
    data = SUM,
    aes(x = peakStress_bin, y = mean_y),
    fill = "white",
    color = "black",
    size = 3,
    shape = 21,
    stroke = 0.8
  ) +
  geom_errorbar(
    data = SUM,
    aes(
      x = peakStress_bin,
      ymin = mean_y - ci95,
      ymax = mean_y + ci95
    ),
    width = 0.1,
    color = error_color,
    linewidth = 1
  ) +
  geom_line(
    data = SUM,
    aes(x = as.numeric(peakStress_bin), y = mean_y, group = 1),
    color = "grey40",
    linewidth = 0.8
  ) +
  labs(
    x = "Peak Stress (MPa) — Quartile Bins",
    y = "Percent Relaxation (%)",
    title = "Percent Relaxation by Peak Stress Quartiles (Raw Data + Mean ± 95% CI)"
  ) +
  theme_bw(base_size = 14) +
  theme(
    axis.title = element_text(face = "bold"),
    axis.text  = element_text(color = "black"),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", hjust = 0.5)
  )

## 1.0 Plotting Discrete Data --------------------------------------------------
# Anscombe's Quartet and the Importance of Checking Assumptions
#DAT1 <- read.csv("./data/data_ANSCOMBE.csv", header = TRUE, sep = ",")
#head(DAT1)

## Regression Coefficients ---- 
COEFS<-DATA1 %>%
  group_by(ID) %>%
  summarise(Intercept=lm(yVal~xVal, data=DATA1)$coefficients[1],
            Slope=lm(yVal~xVal, data=DATA1)$coefficients[2],
            MeanY=mean(yVal),
            SDY = sd(yVal),
            MeanX=mean(xVal),
            SDX = sd(xVal))
COEFS


# Visualizing All the Data
ggplot(DAT1, aes(x = xVal, y = yVal)) +
  geom_point(aes(fill=as.factor(group)), pch=21, color="black", size=2)+
  stat_smooth(aes(col=as.factor(group)), method="lm", se=FALSE, lwd=1)+
  facet_wrap(~group, ncol=2)+
  scale_x_continuous(name = "X Values") +
  scale_y_continuous(name = "Y Values") +
  theme(axis.text=element_text(size=16, color="black"), 
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        #axis.text.y=element_blank(),
        #axis.title.y=element_blank(),
        #axis.ticks.y=element_blank(),
        legend.position = "none")




## Disctrete Categorical Data
DAT2 <- read.csv("./data/data_FINAL_RATINGS.csv", header = TRUE, sep = ",")
head(DAT2)


MEANS<-DAT2 %>%
  group_by(Elevation, Speed) %>%
  summarise(ave_Effort=mean(Effort),
            N = length(Effort),
            SD = sd(Effort))

MEANS

# Just the means
ggplot(MEANS, aes(x = Elevation, y = ave_Effort)) +
  geom_bar(aes(fill=Elevation), stat="identity", width = 0.5)+
  facet_wrap(~Speed) +
  scale_y_continuous(name = "Effort (%)", limits = c(0,100)) +
  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+ 
  #scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  theme(axis.text=element_text(size=16, color="black"), 
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"),
        legend.position = "none")


# Means with Standard errors
ggplot(MEANS, aes(x = Elevation, y = ave_Effort)) +
  geom_bar(aes(fill=Elevation, col=Elevation), 
           stat="identity", width = 0.5)+
  geom_errorbar(aes(ymin = ave_Effort-SD/sqrt(N), ymax=ave_Effort+SD/sqrt(N)),
                width = 0.2)+
  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+
  facet_wrap(~Speed) +
  scale_y_continuous(name = "Effort (%)", limits = c(0,100)) +
  theme(axis.text=element_text(size=16, color="black"), 
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"),
        legend.position = "none")


# All the data
ggplot(DAT2, aes(x = Elevation, y = Effort)) +
  geom_point(aes(fill=Elevation), pch=21, size=2,
             position=position_jitter(w=0.2, h=0))+
  facet_wrap(~Speed) +
  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+ 
  scale_y_continuous(name = "Effort (%)", limits = c(0,100)) +
  theme(axis.text=element_text(size=16, color="black"), 
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"),
        legend.position = "none")


# Boxplots
ggplot(DAT2, aes(x = Elevation, y = Effort)) +
  geom_point(aes(fill=Elevation), pch=21, size=2,
             position=position_jitter(w=0.2, h=0))+
  geom_boxplot(fill="white", col="black", outlier.shape = "na",
               alpha=0.4, width=0.5)+
  facet_wrap(~Speed) +
  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+  
  scale_y_continuous(name = "Effort (%)", limits = c(0,100)) +
  theme(axis.text=element_text(size=16, color="black"), 
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"),
        legend.position = "none")


# Connect the dots
head(DAT2)
DAT3 <- DAT2 %>% 
  group_by(Elevation, Speed) %>%
  summarise(Effort=mean(Effort))
head(DAT3)

ggplot(DAT2, aes(x = Elevation, y = Effort)) +
  geom_point(aes(fill=Elevation), pch=21, size=2)+
  geom_line(aes(group=SUBJ, lty=Speed), col="grey40")+
  facet_wrap(~Speed) +
  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+
  scale_y_continuous(name = "Effort (%)", limits = c(0,100)) +
  theme(axis.text=element_text(size=16, color="black"), 
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"),
        legend.position = "none") +
  stat_smooth(aes(group=Speed, lty=Speed), col="black", lwd=2, se=FALSE)+
  geom_point(data=DAT3, aes(fill=Elevation), shape=22, size=5)







# 2.0 Visualizing Continuous Data ----------------------------------------------
# Acquisition Data -------------------------------------------------------------
list.files()
ACQ<-read.csv("./data_CI_ERRORS.csv", header = TRUE, sep=",",  
              na.strings=c("NA","NaN"," ",""))
head(ACQ)
ACQ$subID<-factor(ACQ$subID)
ACQ$target_nom<-factor(ACQ$target)

# Removing Outliers
ACQ <- subset(ACQ, absolute_error < 1000)

head(ACQ)

ggplot(data=ACQ, aes(x=target+constant_error))+
  geom_density(aes(col=target_nom, fill=target_nom), alpha=0.4)+
  facet_wrap(~group)+
  scale_fill_manual(values=c("#000000","#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#000000", "#E69F00", "#56B4E9"))+
  scale_x_continuous(name="Time Produced (ms)")+
  scale_y_continuous(name = "Density", limits = c(0,0.003)) +  
  labs(fill = "Target (ms)", col="Target (ms)")+
  theme(axis.text=element_text(size=12, color="black"), 
        legend.text=element_text(size=16, color="black"),
        legend.title=element_text(size=16, face="bold"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"))


# Post-Test Data ---------------------------------------------------------------
POST<-read.csv("./Post Data_Long Form.csv", header=TRUE)
head(POST)

POST$Participant<-factor(POST$Participant)
POST$target_nom<-factor(POST$Target.Time)
POST<-subset(POST, Absolute.Error < 1000)


# Subsetting into retention and transfer
RET <- subset(POST, Target.Time == 1500|Target.Time == 1700|Target.Time == 1900)

# Retention Data
ggplot(data=RET, aes(x=target_nom, y=Absolute.Error))+
  scale_fill_manual(values=c("#000000","#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#000000", "#E69F00", "#56B4E9"))+
  geom_jitter(aes(group=Group, fill=target_nom), pch=21, position=position_jitterdodge(dodge.width=0.8))+
  geom_boxplot(aes(lty=Group, col=target_nom), fill="white", 
               alpha=0.4, outlier.shape = NA)

ggplot(data=RET, aes(x=Target.Time+Constant.Error))+
  geom_density(aes(col=target_nom, fill=target_nom), alpha=0.4)+
  facet_wrap(~Group) +
  scale_fill_manual(values=c("#000000","#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#000000", "#E69F00", "#56B4E9"))+
  scale_x_continuous(name="Time Produced (ms)")+
  scale_y_continuous(name = "Density", limits = c(0,0.003)) +
  labs(fill = "Target (ms)", col="Target (ms)")+
  theme(axis.text=element_text(size=12, color="black"), 
        legend.text=element_text(size=16, color="black"),
        legend.title=element_text(size=16, face="bold"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"))


# Longitudinal Plots of Practice Data ------------------------------------------
# Aggregate Practice Data into Blocks
head(ACQ)

ACQ_AVE<-ACQ %>%
  group_by(subID, group, block) %>%
  summarise(CE_AVE = mean(constant_error, na.rm=TRUE),
            AE_AVE = mean(absolute_error, na.rm=TRUE))

head(ACQ_AVE)

sd(ACQ_AVE$CE_AVE)

ACQ_GROUP_AVE<-ACQ_AVE %>%
  group_by(group, block) %>%
  summarise(CE = mean(CE_AVE, na.rm=TRUE),
            CE_sd = sd(CE_AVE, na.rm=TRUE),
            AE = mean(AE_AVE, na.rm=TRUE),
            AE_sd = sd(AE_AVE, na.rm=TRUE),
            N=length(AE_AVE))

head(ACQ_GROUP_AVE)

# More traditional plot averaging across trials ----
ggplot(ACQ_GROUP_AVE, aes(x = block, y = AE)) +
  geom_line(aes(col=group), lwd=1)+
  geom_errorbar(aes(ymin = AE-AE_sd/sqrt(N), ymax=AE+AE_sd/sqrt(N)),
                width = 0.1)+
  geom_point(aes(fill=group), shape=21, size=2)+
  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+
  scale_x_continuous(name = "Block", breaks = c(1,2,3)) +
  scale_y_continuous(name = "Absolute Error (ms)", limits = c(0,250)) +
  labs(fill = "Group", col="Group")+
  theme(axis.text=element_text(size=16, color="black"), 
        legend.text=element_text(size=16, color="black"),
        legend.title=element_text(size=16, face="bold"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"),
        legend.position = "top")


head(ACQ)
ggplot(ACQ, aes(x = trial_total, y = absolute_error , group=subID)) +
  geom_line(aes(col=group), lwd=1)+
  geom_point(aes(fill=group), shape=21, size=2)+
  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+  
  scale_x_continuous(name = "Trial") +
  scale_y_continuous(name = "Absolute Error (ms)") +
  facet_wrap(~target, ncol=1)+
  labs(fill = "Group", col="Group")+
  theme(axis.text=element_text(size=16, color="black"), 
        legend.text=element_text(size=16, color="black"),
        legend.title=element_text(size=16, face="bold"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"),
        legend.position = "top")

ggplot(ACQ, aes(x = trial_total, y = absolute_error)) +
  geom_point(aes(fill=group), shape=21, size=1, alpha=0.3)+
  stat_smooth(aes(group=group, lty=group), col="black", fill="white",
              method="loess", lwd=1, se=TRUE)+
  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+  
  scale_x_continuous(name = "Trial") +
  scale_y_continuous(name = "Absolute Error (ms)") +
  facet_grid(~group+target)+
  labs(fill = "Group", lty="Group")+
  theme(axis.text.x = element_text(size=10, color="black"),
        axis.text.y=element_text(size=14, color="black"), 
        legend.text=element_text(size=14, color="black"),
        legend.title=element_text(size=14, face="bold"),
        axis.title=element_text(size=14, face="bold"),
        plot.title=element_text(size=14, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=14, face="bold"),
        legend.position = "none")


head(ACQ_AVE)

ACQ_BLOCK_AVE<-ACQ %>%
  group_by(subID, group, block, target) %>%
  summarise(CE = mean(constant_error, na.rm=TRUE),
            AE = mean(absolute_error, na.rm=TRUE))

head(ACQ_BLOCK_AVE)
head(ACQ_GROUP_AVE)

ggplot(ACQ_BLOCK_AVE, aes(x = block, y = AE)) +
  geom_point(aes(fill=group), col="black", 
             shape=21, size=2, alpha=0.5)+
  #geom_line(aes(group=subID), size=1, alpha=0.5)+
  geom_line(data=ACQ_GROUP_AVE, aes(col=group), lwd=1)+
  geom_point(data=ACQ_GROUP_AVE, aes(fill=group),
             col="black", shape=21, size=5, alpha=0.5)+
  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+
  scale_x_continuous(name = "Block", breaks=c(1,2,3)) +
  scale_y_continuous(name = "Absolute Error (ms)") +
  facet_grid(~target)+
  labs(fill = "Group", col="Group")+
  theme(axis.text.x = element_text(size=14, color="black"),
        axis.text.y=element_text(size=14, color="black"), 
        legend.text=element_text(size=14, color="black"),
        legend.title=element_text(size=14, face="bold"),
        axis.title=element_text(size=14, face="bold"),
        plot.title=element_text(size=14, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=14, face="bold"),
        legend.position = "top")


