

# First set working directory to source file location
# Run with command + option + R

library(tidyverse)
library(reshape2)
library(stringr)
library(formattable)
library(broom)
library(RColorBrewer)

#Add to the nuclei.csv file: Object_ID, job, drug & replicate
#Add to Cells.csv & Cytoplasm.csv: Object_ID

datafolder1 <- "~/Desktop/W1/20210409_Dwinell_newdrugaliquot/change_2nd_ob/cellprofiler_output/compiled_allNs/GitHub/"


#Import, separate file name from extension & isolate Pearson & MitoGraph Scores
Summary_nuclear <- read_csv(paste(datafolder1,"Nuclei_all.csv",sep=''))
Summary_cells <- read_csv(paste(datafolder1,"Cells_all.csv",sep=''))
Summary_cytoplasm <- read_csv(paste(datafolder1,"Cytoplasm_all.csv",sep=''))

Summary_nuclear <- Summary_nuclear %>%
  rename(dapi_mean = Intensity_MeanIntensity_DAPI_cropped) %>%
  rename(nuclear_mean = Intensity_MeanIntensity_FOXO_cropped) %>%
  rename(nuclear_area = AreaShape_Area) %>%
  select(., Object_ID, FileName_DAPI, job, drug, replicate, dapi_mean, nuclear_mean, nuclear_area)

Summary_cells <- Summary_cells %>%
  rename(cells_mean_FOXO = Intensity_MeanIntensity_FOXO_cropped) %>%
  rename(cells_mean_Actin = Intensity_MeanIntensity_Actin_cropped) %>%
  rename(cells_area = AreaShape_Area) %>%
  select(., Object_ID, cells_mean_FOXO, cells_mean_Actin, cells_area)

Summary_cytoplasm <- Summary_cytoplasm %>%
  rename(cytoplasm_mean = Intensity_MeanIntensity_FOXO_cropped) %>%
  select(., Object_ID, cytoplasm_mean)

merged_data <- merge(Summary_nuclear, Summary_cells, by="Object_ID")
merged_data <- merge(merged_data, Summary_cytoplasm, by="Object_ID")
merged_data <- transform(merged_data, nucleus_dv_cytoplasm = nuclear_mean / cytoplasm_mean)
merged_data <- transform(merged_data, cells_norm_dapi = cells_mean_FOXO / dapi_mean)

#RENAME with your sample order, names must match
merged_data <- merged_data %>%
  mutate(job = factor(job, 
                      levels = c("vehicle_N1",
                                 "LY_N1",
                                 "[0.3]_N1",
                                 "[0.5]_N1",
                                 "vehicle_N2",
                                 "LY_N2",
                                 "[0.3]_N2",
                                 "[0.5]_N2",
                                 "vehicle_N3",
                                 "LY_N3",
                                 "[0.3]_N3",
                                 "[0.5]_N3",
                                 "vehicle_N4",
                                 "LY_N4",
                                 "[0.3]_N4",
                                 "[0.5]_N4",
                                 "vehicle_N5",
                                 "LY_N5",
                                 "[0.3]_N5",
                                 "[0.5]_N5",
                                 "vehicle_N6",
                                 "LY_N6",
                                 "[0.3]_N6",
                                 "[0.5]_N6"), ordered = T))

merged_data <- merged_data %>%
  mutate(drug = factor(drug, 
                      levels = c("vehicle",
                                 "LY",
                                 "[0.3]",
                                 "[0.5]"), ordered = T))

merged_data <- merged_data %>%
  mutate(replicate = factor(replicate, 
                       levels = c("N1",
                                  "N2",
                                  "N3",
                                  "N4",
                                  "N5",
                                  "N6"), ordered = T))%>%
  #filter(replicate == "N1" | replicate == "N4") %>%
  filter(cytoplasm_mean > 0) %>%   #remove objects that are just nuclei and no cytoplasm
  filter(cytoplasm_mean < 0.005)   #remove bright objects, some of the samples had bright debri in a few images that skewed the means
  
###############################
# PLOT individual channel means
###############################
###ACTIN - whole cell object###
ggplot(merged_data, aes(fill=drug, x=replicate, y=cells_mean_Actin)) +
  stat_boxplot(geom = "errorbar", colour = "grey15", width = 0.5, position = position_dodge (width = 0.9)) +
  geom_boxplot (outlier.size = 0, colour = "grey15", position = position_dodge (width = 0.9)) +
  stat_boxplot(geom="errorbar", position = position_dodge (width = 0.9), width = 0.5, size = 0.25) +
  scale_fill_manual(values = c("#FFFFFF", "#00c000","#5757F9","#0000C0")) +
  stat_summary(fun = "mean", geom = "point", shape = 8, size = 0.5, color = "white", position = position_dodge (width = 0.9)) +
  #geom_point (aes(colour = drug, x=replicate, y=cells_mean_Actin), pch=20, position=position_jitterdodge(jitter.width=0.1, jitter.height=0, dodge.width=0.9), size = 0.01) +
  #scale_colour_manual(values = c("grey25","grey25","grey25","grey25","grey25","grey25","grey25","grey25")) +
  geom_vline(xintercept=c(1.5,2.5, 3.5, 4.5, 5.5), color = "grey50", linetype = "longdash") +
  labs(title = "Actin cellular mean",
       x = "conditions tested",
       y = "Actin_cellular_mean") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 8, color = "black"),
        axis.text.y = element_text(size = 8, color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "grey75", size = 0.5, linetype = 1), 
        axis.line.y = element_line(color = "grey75", size = 0.5, linetype = 1), 
        legend.title = element_blank(),
        legend.justification = c(0, 1), 
        #legend.position = "none", #"right",
        legend.text = element_text(size = 8, color = "black"), 
        strip.background = element_rect(fill = "white"),
        strip.text.x = element_text(size = 6, colour = "black")
  ) 

ggsave(paste("Actin_cellmean.eps",sep=""), width = 25, height = 16, units = "cm", dpi = 300)
ggsave(paste("Actin_cellmean.png",sep=""), width = 25, height = 16, units = "cm", dpi = 300)


###DAPI - nuclear object###

ggplot(merged_data, aes(fill=drug, x=replicate, y=dapi_mean)) +
  stat_boxplot(geom = "errorbar", colour = "grey15", width = 0.5, position = position_dodge (width = 0.9)) +
  geom_boxplot (outlier.size = 0, colour = "grey15", position = position_dodge (width = 0.9)) +
  stat_boxplot(geom="errorbar", position = position_dodge (width = 0.9), width = 0.5, size = 0.25) +
  scale_fill_manual(values = c("#FFFFFF", "#00c000","#5757F9","#0000C0")) +
  stat_summary(fun = "mean", geom = "point", shape = 8, size = 0.5, color = "white", position = position_dodge (width = 0.9)) +
  #geom_point (aes(colour = drug, x=replicate, y=dapi_mean), pch=20, position=position_jitterdodge(jitter.width=0.1, jitter.height=0, dodge.width=0.9), size = 0.01) +
  #scale_colour_manual(values = c("grey25","grey25","grey25","grey25","grey25","grey25","grey25","grey25")) +
  geom_vline(xintercept=c(1.5,2.5, 3.5, 4.5, 5.5), color = "grey50", linetype = "longdash") +
  labs(title = "DAPI nuclear mean",
       x = "conditions tested",
       y = "DAPI_nuclear_mean") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 8, color = "black"),
        axis.text.y = element_text(size = 8, color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "grey75", size = 0.5, linetype = 1), 
        axis.line.y = element_line(color = "grey75", size = 0.5, linetype = 1), 
        legend.title = element_blank(),
        legend.justification = c(0, 1), 
        #legend.position = "none", #"right",
        legend.text = element_text(size = 8, color = "black"), 
        strip.background = element_rect(fill = "white"),
        strip.text.x = element_text(size = 6, colour = "black")
  ) 

ggsave(paste("DAPI_nuc_mean.eps",sep=""), width = 25, height = 16, units = "cm", dpi = 300)
ggsave(paste("DAPI_nuc_mean.png",sep=""), width = 25, height = 16, units = "cm", dpi = 300)

###FOXO - whole cell object###

ggplot(merged_data, aes(fill=drug, x=replicate, y=cells_mean_FOXO)) +
  stat_boxplot(geom = "errorbar", colour = "grey15", width = 0.5, position = position_dodge (width = 0.9)) +
  geom_boxplot (outlier.size = 0, colour = "grey15", position = position_dodge (width = 0.9)) +
  stat_boxplot(geom="errorbar", position = position_dodge (width = 0.9), width = 0.5, size = 0.25) +
  scale_fill_manual(values = c("#FFFFFF", "#00c000","#5757F9","#0000C0")) +
  stat_summary(fun = "mean", geom = "point", shape = 8, size = 0.5, color = "white", position = position_dodge (width = 0.9)) +
  #geom_point (aes(colour = drug, x=replicate, y=cells_mean_FOXO), pch=20, position=position_jitterdodge(jitter.width=0.1, jitter.height=0, dodge.width=0.9), size = 0.01) +
  #scale_colour_manual(values = c("grey25","grey25","grey25","grey25","grey25","grey25","grey25","grey25")) +
  geom_vline(xintercept=c(1.5,2.5, 3.5, 4.5, 5.5), color = "grey50", linetype = "longdash") +
  labs(title = "FoxO cellular mean",
       x = "conditions tested",
       y = "FoxO_cellular_mean") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 8, color = "black"),
        axis.text.y = element_text(size = 8, color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "grey75", size = 0.5, linetype = 1), 
        axis.line.y = element_line(color = "grey75", size = 0.5, linetype = 1), 
        legend.title = element_blank(),
        legend.justification = c(0, 1), 
        #legend.position = "none", #"right",
        legend.text = element_text(size = 8, color = "black"), 
        strip.background = element_rect(fill = "white"),
        strip.text.x = element_text(size = 6, colour = "black")
  ) 

ggsave(paste("FoxO_cellmean.eps",sep=""), width = 25, height = 16, units = "cm", dpi = 300)
ggsave(paste("FoxO_cellmean.png",sep=""), width = 25, height = 16, units = "cm", dpi = 300)

###FOXO- nuclear object mean###

ggplot(merged_data, aes(fill=drug, x=replicate, y=nuclear_mean)) +
  stat_boxplot(geom = "errorbar", colour = "grey15", width = 0.5, position = position_dodge (width = 0.9)) +
  geom_boxplot (outlier.size = 0, colour = "grey15", position = position_dodge (width = 0.9)) +
  stat_boxplot(geom="errorbar", position = position_dodge (width = 0.9), width = 0.5, size = 0.25) +
  scale_fill_manual(values = c("#FFFFFF", "#00c000","#5757F9","#0000C0")) +
  stat_summary(fun = "mean", geom = "point", shape = 8, size = 0.5, color = "white", position = position_dodge (width = 0.9)) +
  #geom_point (aes(colour = drug, x=replicate, y=nuclear_mean), pch=20, position=position_jitterdodge(jitter.width=0.1, jitter.height=0, dodge.width=0.9), size = 0.01) +
  #scale_colour_manual(values = c("grey25","grey25","grey25","grey25","grey25","grey25","grey25","grey25")) +
  geom_vline(xintercept=c(1.5,2.5, 3.5, 4.5, 5.5), color = "grey50", linetype = "longdash") +
  labs(title = "FoxO nuclear mean",
       x = "conditions tested",
       y = "FOXO_nuclear_mean") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 8, color = "black"),
        axis.text.y = element_text(size = 8, color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "grey75", size = 0.5, linetype = 1), 
        axis.line.y = element_line(color = "grey75", size = 0.5, linetype = 1), 
        legend.title = element_blank(),
        legend.justification = c(0, 1), 
        #legend.position = "none", #"right",
        legend.text = element_text(size = 8, color = "black"), 
        strip.background = element_rect(fill = "white"),
        strip.text.x = element_text(size = 6, colour = "black")
  ) 

ggsave(paste("nuclear_mean.eps",sep=""), width = 25, height = 16, units = "cm", dpi = 300)
ggsave(paste("nuclear_mean.png",sep=""), width = 25, height = 16, units = "cm", dpi = 300)

###FOXO - cytoplasm object mean###

ggplot(merged_data, aes(fill=drug, x=replicate, y=cytoplasm_mean)) +
  stat_boxplot(geom = "errorbar", colour = "grey15", width = 0.5, position = position_dodge (width = 0.9)) +
  geom_boxplot (outlier.size = 0, colour = "grey15", position = position_dodge (width = 0.9)) +
  stat_boxplot(geom="errorbar", position = position_dodge (width = 0.9), width = 0.5, size = 0.25) +
  scale_fill_manual(values = c("#FFFFFF", "#00c000","#5757F9","#0000C0")) +
  stat_summary(fun = "mean", geom = "point", shape = 8, size = 0.5, color = "white", position = position_dodge (width = 0.9)) +
  #geom_point (aes(colour = drug, x=replicate, y=cytoplasm_mean), pch=20, position=position_jitterdodge(jitter.width=0.1, jitter.height=0, dodge.width=0.9), size = 0.01) +
  #scale_colour_manual(values = c("grey25","grey25","grey25","grey25","grey25","grey25","grey25","grey25")) +
  geom_vline(xintercept=c(1.5,2.5, 3.5, 4.5, 5.5), color = "grey50", linetype = "longdash") +
  labs(title = "FoxO cytoplasmic mean",
       x = "conditions tested",
       y = "FOX-O_cytoplasm_mean") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 8, color = "black"),
        axis.text.y = element_text(size = 8, color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "grey75", size = 0.5, linetype = 1), 
        axis.line.y = element_line(color = "grey75", size = 0.5, linetype = 1), 
        legend.title = element_blank(),
        legend.justification = c(0, 1), 
        #legend.position = "none", #"right",
        legend.text = element_text(size = 8, color = "black"), 
        strip.background = element_rect(fill = "white"),
        strip.text.x = element_text(size = 6, colour = "black")
  ) 

ggsave(paste("FOXOcytoplasmic_mean.eps",sep=""), width = 25, height = 16, units = "cm", dpi = 300)
ggsave(paste("FOXOcytoplasmic_mean.png",sep=""), width = 25, height = 16, units = "cm", dpi = 300)

###FOXO- nuclear mean / cytosolic mean mean###

ggplot(merged_data, aes(fill=drug, x=replicate, y=nucleus_dv_cytoplasm)) +
  stat_boxplot(geom = "errorbar", colour = "grey15", width = 0.5, position = position_dodge (width = 0.9)) +
  geom_boxplot (outlier.size = 0, colour = "grey15", position = position_dodge (width = 0.9)) +
  stat_boxplot(geom="errorbar", position = position_dodge (width = 0.9), width = 0.5, size = 0.25) +
  scale_fill_manual(values = c("#FFFFFF", "#00c000","#5757F9","#0000C0")) +
  stat_summary(fun = "mean", geom = "point", shape = 8, size = 0.5, color = "white", position = position_dodge (width = 0.9)) +
  #geom_point (aes(colour = drug, x=replicate, y=nucleus_dv_cytoplasm), fill = "white", position=position_jitterdodge(jitter.width=0.1, jitter.height=0, dodge.width=0.9), size = 0.1) +
  #scale_colour_manual(values = c("grey5", "#00c000","#5757F9","#0000C0")) +
  ylim(0.5,1.75)+
  geom_vline(xintercept=c(1.5,2.5, 3.5, 4.5, 5.5), color = "grey50", linetype = "longdash") +
  labs(title = "FoxO nucleus_dv_cytoplasm",
       x = "replicate",
       y = "FoxO nucleus_dv_cytoplasm") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 10, color = "black"),
        axis.text.y = element_text(size = 10, color = "black"),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 10, color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "black", size = 0.5, linetype = 1), 
        axis.line.y = element_line(color = "black", size = 0.5, linetype = 1), 
        legend.title = element_blank(),
        legend.justification = c(0, 1), 
        #legend.position = "none", #"right",
        legend.text = element_text(size = 8, color = "black"), 
        strip.background = element_rect(fill = "white"),
        strip.text.x = element_text(size = 10, colour = "black")
  ) 

ggsave(paste("nucleus_dv_cytoplasm.eps",sep=""), width = 11, height = 10, units = "cm", dpi = 300)
ggsave(paste("nucleus_dv_cytoplasm.png",sep=""), width = 25, height = 16, units = "cm", dpi = 300)

###FOXO- nuclear mean / cytosolic mean mean; plot all in one###

ggplot(merged_data, aes(fill=drug, x=drug, y=nucleus_dv_cytoplasm)) +
  stat_boxplot(geom = "errorbar", colour = "grey15", width = 0.5, position = position_dodge (width = 0.9)) +
  geom_boxplot (outlier.size = 0, colour = "grey15", position = position_dodge (width = 0.9)) +
  stat_boxplot(geom="errorbar", position = position_dodge (width = 0.9), width = 0.5, size = 0.25) +
  scale_fill_manual(values = c("#FFFFFF", "#00c000","#5757F9","#0000C0")) +
  stat_summary(fun = "mean", geom = "point", shape = 8, size = 2, color = "white", position = position_dodge (width = 0.9)) +
  geom_point (aes(colour = drug, x=drug, y=nucleus_dv_cytoplasm), pch=20, position=position_jitterdodge(jitter.width=1, jitter.height=0, dodge.width=0.9), size = 0.0001) +
  scale_colour_manual(values = c("grey75","grey75","grey75","grey75")) +
  labs(title = "FoxO nucleus_dv_cytoplasm",
       x = "drug",
       y = "FoxO nucleus_dv_cytoplasm") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 8, color = "black"),
        axis.text.y = element_text(size = 8, color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "grey75", size = 0.5, linetype = 1), 
        axis.line.y = element_line(color = "grey75", size = 0.5, linetype = 1), 
        legend.title = element_blank(),
        legend.justification = c(0, 1), 
        #legend.position = "none", #"right",
        legend.text = element_text(size = 8, color = "black"), 
        strip.background = element_rect(fill = "white"),
        strip.text.x = element_text(size = 6, colour = "black")
  ) 

ggsave(paste("nucleus_dv_cytoplasm_sum.eps",sep=""), width = 15, height = 16, units = "cm", dpi = 300)
ggsave(paste("nucleus_dv_cytoplasm_sum.png",sep=""), width = 15, height = 16, units = "cm", dpi = 300)

#AOV_STATS (ANOVA and TUKEY Post Hoc analysis)

AOV_STATS <- TukeyHSD(aov(data=merged_data, nucleus_dv_cytoplasm~drug))

AOV_Table <- (AOV_STATS)

AOV_Table_summary <- as.data.frame(AOV_Table[1:1])

write.csv(AOV_Table_summary, paste("ALL_AOV_stats_nucleus_dv_cytoplasm.csv",sep=""))

formattable(AOV_Table_summary, Condition.p.adj=formatter("span", style = x~style(color=ifelse(x < 0.05 , "green", "black"))))

#Calculate replicate means

summary_data_mean <- aggregate(merged_data$nucleus_dv_cytoplasm, by=list(merged_data$job), FUN=mean)
summary_data_mean <- summary_data_mean %>%
  rename(job = Group.1) %>%
  rename(mean_nucleus_dv_cytoplasm = x)

write.csv(summary_data_mean, paste("Mean_nucleus_dv_cytoplasm_all.csv",sep=""))

#add column for drug and rename .csve to include _update

#########This portion of the script plots the means of all 6 replicates above############

merged_data2 <- read_csv(paste(datafolder1,"Mean_nucleus_dv_cytoplasm_all_update.csv",sep=''))

#RENAME with your sample order, names must match
merged_data2 <- merged_data2 %>%
  mutate(job = factor(job, 
                      levels = c("vehicle_N1",
                                 "LY_N1",
                                 "[0.3]_N1",
                                 "[0.5]_N1",
                                 "vehicle_N2",
                                 "LY_N2",
                                 "[0.3]_N2",
                                 "[0.5]_N2",
                                 "vehicle_N3",
                                 "LY_N3",
                                 "[0.3]_N3",
                                 "[0.5]_N3",
                                 "vehicle_N4",
                                 "LY_N4",
                                 "[0.3]_N4",
                                 "[0.5]_N4",
                                 "vehicle_N5",
                                 "LY_N5",
                                 "[0.3]_N5",
                                 "[0.5]_N5",
                                 "vehicle_N6",
                                 "LY_N6",
                                 "[0.3]_N6",
                                 "[0.5]_N6"), ordered = T))

merged_data2 <- merged_data2 %>%
  mutate(drug = factor(drug, 
                       levels = c("vehicle",
                                  "LY",
                                  "[0.3]",
                                  "[0.5]"), ordered = T))

ggplot(merged_data2, aes(fill=drug, x=drug, y=mean_nucleus_dv_cytoplasm)) +
  stat_boxplot(geom = "errorbar", colour = "grey15", width = 0.5, position = position_dodge (width = 0.9), size = 0.5) +
  geom_boxplot (outlier.size = 0, colour = "grey15", position = position_dodge (width = 0.9), size = 0.5) +
  stat_boxplot(geom="errorbar", position = position_dodge (width = 0.9), width = 0.5, size = 0.5) +
  scale_fill_manual(values = c("#FFFFFF", "#00c000","#5757F9","#0000C0")) +
  stat_summary(fun = "mean", geom = "point", shape = 8, size =0.75 , color = "grey75", position = position_dodge (width = 0.9)) +
  geom_point (aes(colour = drug, x=drug, y=mean_nucleus_dv_cytoplasm, shape=drug), fill = "white", position=position_jitterdodge(jitter.width=1, jitter.height=0, dodge.width=0.9), size = 0.5) +
  scale_shape_manual(values = c(16,22 ,24,25)) +
  scale_colour_manual(values = c("black","black","black","black")) +
  labs(title = "FoxO nucleus_dv_cytoplasm",
    x = "drug",
    y = "FoxO nuclear/cytoplasmic mean") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 6, color = "black"),
        axis.text.y = element_text(size = 6, color = "black"),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 6, color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(color = "black", size = 0.5, linetype = 1), 
        axis.line.y = element_line(color = "black", size = 0.5, linetype = 1), 
        legend.title = element_blank(),
        legend.justification = c(0, 1), 
        legend.position = "none", #"right",
        #legend.text = element_text(size = 8, color = "black"), 
        strip.background = element_rect(fill = "white"),
        strip.text.x = element_text(size = 6, colour = "black")
  ) 

ggsave(paste("nucleus_dv_cytoplasm_ALL.eps",sep=""), width = 42.408, height = 35.569, units = "mm", dpi = 300)
ggsave(paste("nucleus_dv_cytoplasm_ALL.png",sep=""), width = 42.408, height = 35.569, units = "mm", dpi = 300)

AOV_STATS <- TukeyHSD(aov(data=merged_data2, mean_nucleus_dv_cytoplasm~drug))

AOV_Table <- (AOV_STATS)

AOV_Table_summary <- as.data.frame(AOV_Table[1:1])

write.csv(AOV_Table_summary, paste("Mean_AOV_stats_nucleus_dv_cytoplasm.csv",sep=""))

formattable(AOV_Table_summary, Condition.p.adj=formatter("span", style = x~style(color=ifelse(x < 0.05 , "green", "black"))))
