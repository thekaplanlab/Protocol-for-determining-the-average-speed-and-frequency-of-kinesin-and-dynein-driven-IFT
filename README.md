# Protocol for determining the average speed and frequency of kinesin and dynein driven Intraflagellar Transport (IFT) in *C. elegans*



## This repository contains R codes used for generating the IFT frequency graph and stats (given below) published from ***"Protocol for determining the average speed and frequency of kinesin and dynein driven Intraflagellar Transport (IFT) in C. elegans."*** paper. 


![Rplot](https://user-images.githubusercontent.com/96948625/160301234-2512d8c5-5a32-488c-b19b-7a2bb0204a8e.png)

>>doi: 

### Steps for generating boxplot from .csv file. 

#### 1. Upload required packages and read .csv file. 
```Phyton
library(ggpubr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(colorspace)


data<- read.csv("/Users/Desktop/Manuscripts/STAR_protocol_IFT/Code/frequency.csv", sep = ",", header = T)
```
#### 2. Change column names
```Phyton
data = rename(data, c("WT - Anterograde"="WT_A", "WT - Retrograde"="WT_R", "wdr-31;elmd-1;rpi-2 - Anterograde"="T_A",
                      "wdr-31;elmd-1;rpi-2 - Retrograde"="T_R"))
```
#### 3. Distrupt columns with column names using pivot_longer() function for obtaining longer dataset.
```Phyton
data_ <- data %>%
  pivot_longer(
    cols = c("WT - Anterograde","WT - Retrograde","wdr-31;elmd-1;rpi-2 - Anterograde",
             "wdr-31;elmd-1;rpi-2 - Retrograde"),
    names_to = "Names", 
    values_to = "Frequency",
    values_drop_na = TRUE,
  )
  ```
  #### 4. Reorder columns using levels paramater. 
  ```Phyton
  data_$Names <- factor(data_$Names, levels = c("WT - Anterograde", "wdr-31;elmd-1;rpi-2 - Anterograde", 
                                              "WT - Retrograde", "wdr-31;elmd-1;rpi-2 - Retrograde"))
  ```
  
 ####  5. Generate boxplot using ggplot() and geom_boxplot() functions with detailed theme setting e.g. removing backgrounnd colour or border, giving names to x- and y- axis.
 ```Phyton
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
  ylim(0,1.5)
```
#### 6. Add statical analysis to graph between the reference group and samples using stat_compare_means() function.
```Phyton
stat_compare_means(comparisons = list(c("WT - Anterograde", "wdr-31;elmd-1;rpi-2 - Anterograde")),
                     label = "p.signif" )  +  
  stat_compare_means(label.y = 1.4, label.x.npc = "left") +
  stat_compare_means(comparisons = list(c("WT - Retrograde", "wdr-31;elmd-1;rpi-2 - Retrograde")),
                     label = "p.signif") +
  stat_compare_means(label.y = 1.3, label.x.npc = "center")
 ```
