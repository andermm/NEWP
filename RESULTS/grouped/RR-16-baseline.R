options(crayon.enabled=FALSE)
library("tidyverse")
library("ggplot2")
library("ggpubr")
#############################################################################################################################


df_results16 <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/grouped/rr-802.3ad-16.csv", progress=FALSE)

try <- c(H="High", L="Medium/High", M="Low")

a <- ggplot(df_results16, aes(x=Class, y=Percent, fill=df_results16$`Vms/NICs`)) +
  geom_bar(stat="identity", position = "dodge", colour="black",size=0.1, width = 0.8) +
  scale_y_continuous(labels = function(x) paste0(x*1, "%"), limits = c(-7, 120), breaks = seq(-5, 115, by = 15), expand = c(0, 0)) +
  scale_fill_manual(values=c( "#66c2a5", "#fc8d62", "#8da0cb", "#e78ac3", "#a6d854", "#808585"),
                    breaks=c("0-2", "0-4", "2-2", "2-4", "4-2", "4-4"), labels=c("0  VMs - 2 NICs","0  VMs - 4 NICs", "2  VMs - 2 NICs", "2  VMs - 4 NICs", "4  VMs - 2 NICs", "4  VMs - 4 NICs")) +
  theme_bw(base_size=12) +
  theme(legend.position = c(0.76, 0.75),
        plot.margin = unit(x = c(0, 0.05, 0.8, 0.3), units = "cm"),
        legend.margin=margin(c(0, 0, 0, 0)),
        axis.text.x = element_text(color = "black", size=12,  margin=unit(c(0.5,0.5,0,0), "cm"), vjust=3),
        axis.text.y = element_text(color = "black", size=12,  margin=unit(c(0.5,0.7,0,0), "cm")),
        axis.title=element_text(size=12, color = "black"), 
        legend.title = element_blank(),
        legend.key.size = unit(0.4, 'cm'),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.ticks.length=unit(-0.1, "cm"),
        panel.border = element_rect(color = "black", size=0.8),
        legend.text = element_text(color = "black", size=12)) +
  scale_x_discrete(labels=try) +
  labs(y="RR Performance Gain [%]",
       x="Network Utilization Classification")    
    
################################################################################

df_results64 <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/grouped/rr-802.3ad-64.csv", progress=FALSE)

try <- c(H="High", L="Medium/High", M="Low")

b <- ggplot(df_results64, aes(x=Class, y=Percent, fill=df_results64$`Vms/NICs`)) +
  geom_bar(stat="identity", position = "dodge", colour="black",size=0.1, width = 0.8) +
  scale_y_continuous(labels = function(x) paste0(x*1, "%"), limits = c(-2, 45), breaks = seq(0, 40, by = 10), expand = c(0, 0)) +
  scale_fill_manual(values=c( "#66c2a5", "#fc8d62", "#8da0cb", "#e78ac3", "#a6d854", "#808585"),
                    breaks=c("0-2", "0-4", "2-2", "2-4", "4-2", "4-4"), labels=c("0  VMs - 2 NICs","0  VMs - 4 NICs", "2  VMs - 2 NICs", "2  VMs - 4 NICs", "4  VMs - 2 NICs", "4  VMs - 4 NICs")) +
  theme_bw(base_size=12) +
  theme(
    legend.position = "none",
    plot.margin = unit(x = c(0, 0.03, 0.8, 0.3), units = "cm"),
    axis.text.x = element_text(color = "black", size=12,  margin=unit(c(0.5,0.5,0,0), "cm"), vjust=3),
    axis.text.y = element_text(color = "black", size=12,  margin=unit(c(0.5,0.5,0,0), "cm")),
    axis.title=element_text(size=12, color = "black"), 
    legend.title = element_blank(),
    legend.key = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    axis.ticks.length=unit(-0.1, "cm"),
    panel.border = element_rect(color = "black", size=0.8),
    legend.text = element_blank()) +
  scale_x_discrete(labels=try) +
  labs(y="RR Performance Gain [%]",
       x="Network Utilization Classification")

ggarrange(
  a, b, labels = c("16 Processes", "64 Processes"),font.label=list(color="black",size=12), label.x = 0.33, label.y = 0.1)
ggsave(filename = "/home/mrneverdie/Git/NEWP/RESULTS/grouped/rr-802.3ad.pdf", dpi = 300, width = 218, height = 78, units = "mm", device='pdf')