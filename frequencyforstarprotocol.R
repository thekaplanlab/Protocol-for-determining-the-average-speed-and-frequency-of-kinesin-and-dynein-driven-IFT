library(ggpubr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(colorspace)


data<- read.csv("/Users/oktay/Desktop/Manuscripts/STAR_protocol_IFT/Code/frequency.csv", sep = ",", header = T)


data = rename(data, c("WT - Anterograde"="WT_A", "WT - Retrograde"="WT_R", "wdr-31;elmd-1;rpi-2 - Anterograde"="T_A",
                      "wdr-31;elmd-1;rpi-2 - Retrograde"="T_R"))

colnames(data)

data_ <- data %>%
  pivot_longer(
    cols = c("WT - Anterograde","WT - Retrograde","wdr-31;elmd-1;rpi-2 - Anterograde",
             "wdr-31;elmd-1;rpi-2 - Retrograde"),
    names_to = "Names", 
    values_to = "Frequency",
    values_drop_na = TRUE,
  )
View(data_)
data_$Names <- factor(data_$Names, levels = c("WT - Anterograde", "wdr-31;elmd-1;rpi-2 - Anterograde", 
                                              "WT - Retrograde", "wdr-31;elmd-1;rpi-2 - Retrograde"))


View(data_)
colnames(data_)


data_ %>%
  ggplot(aes(x=Names, y=Frequency, fill= Names))+
  geom_boxplot(aes(color = Names,
                   fill = after_scale(desaturate(lighten(color, 0.6), .3))),
               size = 1) +
  scale_color_brewer(palette = "Set2") +
  geom_jitter(width=0.15, alpha=0.5)+
  theme(axis.line = element_line(colour = "Black"),
        panel.grid.major = element_line(colour = "White"),
        panel.grid.minor = element_line(colour = "White"),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  labs( y = "Frequency (Particle/Sec)") +
  ylim(0,1.5) +
  stat_compare_means(comparisons = list(c("WT - Anterograde", "wdr-31;elmd-1;rpi-2 - Anterograde")),
                     label = "p.signif" )  +  
  stat_compare_means(label.y = 1.4, label.x.npc = "left") +
  stat_compare_means(comparisons = list(c("WT - Retrograde", "wdr-31;elmd-1;rpi-2 - Retrograde")),
                     label = "p.signif") +
  stat_compare_means(label.y = 1.3, label.x.npc = "center")

