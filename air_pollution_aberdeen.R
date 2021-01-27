#look at pollution data
library(reshape2)
library(tidyr)
library(chron)
library(robustbase)
library(plyr)
library(ggplot2)

#data available from https://uk-air.defra.gov.uk/data/data_selector_service
air_data <- read.csv("25078932314.csv", header=T)

#observation times
times <- c("01:00", "02:00", "03:00", "04:00",
           "05:00", "06:00", "07:00", "08:00",
           "09:00", "10:00", "11:00", "12:00",
           "13:00", "14:00", "15:00", "16:00",
           "17:00", "18:00", "19:00", "20:00",
           "21:00", "22:00", "23:00", "24:00")
times_labels <- c("01:00", "", "03:00", "",
                  "05:00", "", "07:00", "",
                  "09:00", "", "11:00", "",
                  "13:00", "", "15:00", "",
                  "17:00", "", "19:00", "",
                  "21:00", "", "23:00", "")

#Aberdeen
Aberdeen <- matrix(as.numeric(air_data[,"Aberdeen"]), ncol=24, nrow=nrow(air_data)/24, byrow=T)
df <- Aberdeen
colnames(df) <- 1:24
df <- melt(df)  
dat <- tibble(
  time = df$Var2, 
  counts = df$value, 
  vars = df$Var1,
  depid = df$depid
)
p <- ggplot(data = dat, mapping = aes(x = time, y = counts, group = vars)) +
  geom_line(aes(x=time), col="lightgray") + theme_light() + 
  scale_y_continuous(name=expression("Nitrogen Dioxide" ~ (mu*g ~ "/" ~ m^{-3}))) + 
  scale_x_continuous(name="Time of Day", breaks=1:24, labels=times_labels) + 
  theme_classic() + 
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=14),
        legend.text=element_text(size=14),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        plot.background = element_rect(fill = "transparent", color = NA),
        legend.background = element_rect(color = NA,fill="transparent"),
        legend.box.background = element_rect(fill = "transparent",color=NA),
        legend.position="none",legend.justification=c(0,1),legend.title=element_blank(),
        legend.key = element_blank())
p
ggsave(p, filename = "Aberdeen.jpg", height=7.16, width=8.44, units="in")

#plot weekend vs weekday
df <- Aberdeen
colnames(df) <- 1:24
df <- melt(df) 
df$depid <- factor(c("Weekday", "Weekend")[as.numeric(is.weekend(as.Date(unique(air_data[,"Date"]), format="%d/%m/%Y")))+1]) 
dat <- tibble(
  time = df$Var2, 
  counts = df$value, 
  vars = df$Var1,
  depid = df$depid
)
p <- ggplot(data = dat, mapping = aes(x = time, y = counts, group = vars, col=depid)) +
  geom_line(aes(x=time)) + theme_light() + 
  scale_y_continuous(name=expression("Nitrogen Dioxide" ~ (mu*g ~ "/" ~ m^{-3}))) + 
  scale_x_continuous(name="Time of Day", breaks=1:24, labels=times_labels) + 
  scale_colour_manual("", values=c("Weekday"="#b2df8a", "Weekend"="#1f78b4")) + 
  theme_classic() + 
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=14),
        legend.text=element_text(size=14),
        plot.background = element_rect(fill = "transparent", color = NA),
        legend.background = element_rect(color = NA,fill="transparent"),
        legend.box.background = element_rect(fill = "transparent",color=NA),
        legend.position=c(0,1),legend.justification=c(0,1),
        legend.title=element_blank(),legend.key = element_blank())
p
ggsave(p, filename = "Aberdeen_weekend.jpg", height=7.16, width=8.44, units="in")

rownames(Aberdeen) <- as.Date(unique(air_data[,"Date"]), format="%d/%m/%Y")
Aberdeen_df <- na.omit(Aberdeen)

#functional anova test 
library(fda.usc)
library(mrfDepth)
dat_fd <- fdata(Aberdeen_df)
groups <- factor(c("Weekday", "Weekend")[as.numeric(is.weekend(as.Date(as.numeric(rownames(Aberdeen_df)), origin="1970-01-01")))+1]) 
res <- fanova.onefactor(dat_fd,groups,nboot=500,plot=TRUE)

#split by weekday vs weekend
Aberdeen_weekend <- Aberdeen_df[is.weekend(as.Date(as.numeric(rownames(Aberdeen_df)), origin="1970-01-01")),]
Aberdeen_weekday <- Aberdeen_df[!is.weekend(as.Date(as.numeric(rownames(Aberdeen_df)), origin="1970-01-01")),]

source("depth_threshold.R")
source("depth.R")
source("plot_depths_function.R")
#calculate functional depth, threshold, and plot
depths_weekend <- depth(Aberdeen_weekend)
c_weekend <- depth_threshold(Aberdeen_weekend)
p <- plot_depths_function(depths_weekend, c_weekend)
p
ggsave(p, filename = "Aberdeen_depths_weekend.jpg", height=7.16, width=8.44, units="in")

depths_weekday <- depth(Aberdeen_weekday)
c_weekday <- depth_threshold(Aberdeen_weekday)
p <- plot_depths_function(depths_weekday, c_weekday)
p
ggsave(p, filename = "Aberdeen_depths_weekday.jpg", height=7.16, width=8.44, units="in")


#define outliers
outliers_weekend <- as.Date(as.numeric(names(depths_weekend)[which(depths_weekend < c_weekend)]), origin="1970-01-01")
outliers_weekday <- as.Date(as.numeric(names(depths_weekday)[which(depths_weekday < c_weekday)]), origin="1970-01-01")
outliers <- c(outliers_weekend, outliers_weekday) 

#plot outliers
df <- Aberdeen
colnames(df) <- 1:24
df <- melt(df) 
df$depid <- factor(c("Normal", "Outlier")[as.numeric(as.Date(unique(air_data[,"Date"]), format="%d/%m/%Y") %in% outliers)+1]) 
dat <- tibble(
  time = df$Var2, 
  counts = df$value, 
  vars = df$Var1,
  depid = df$depid
)
p <- ggplot(data = dat, mapping = aes(x = time, y = counts, group = vars, col=depid)) +
  geom_line(aes(x=time)) + theme_light() + 
  scale_y_continuous(name=expression("Nitrogen Dioxide" ~ (mu*g ~ "/" ~ m^{-3}))) + 
  scale_x_continuous(name="Time of Day", breaks=1:24, labels=times_labels) + 
  scale_colour_manual("", values=c("Normal"="lightgrey", "Outlier"="red")) + 
  theme_classic() + 
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=14),
        legend.text=element_text(size=14),
        plot.background = element_rect(fill = "transparent", color = NA),
        legend.background = element_rect(color = NA,fill="transparent"),
        legend.box.background = element_rect(fill = "transparent",color=NA),
        legend.position=c(0,1),legend.justification=c(0,1),
        legend.title=element_blank(),legend.key = element_blank())
p
ggsave(p, filename = "Aberdeen_outliers.jpg", height=7.16, width=8.44, units="in")




