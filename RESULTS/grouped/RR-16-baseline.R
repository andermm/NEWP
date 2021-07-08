options(crayon.enabled=FALSE)
library("tidyverse")
library("ggplot2")
#############################################################################################################################


df_results <- read_csv("/home/mrneverdie/Desktop/rr-baseline-16.csv", progress=FALSE)

try <- c(H="High Network Utilization", L="Medium/High Network Utilization", M="Low Network Utilization")

ggplot(df_results, aes(x=Class, y=Percent, fill=df_results$`Vms/NICs`)) +
  geom_bar(stat="identity", position = "dodge", colour="black",size=0.1, width = 0.7) +
  scale_fill_manual(values=c( "#66c2a5", "#fc8d62", "#8da0cb", "#e78ac3", "#a6d854", "#808585"),
                    breaks=c("0-2", "0-4", "2-2", "2-4", "4-2", "4-4"), labels=c("0 Parallel VMs - 2 NICs","0 Parallel VMs - 4 NICs", "2 Parallel VMs - 2 NICs", "2 Parallel VMs - 4 NICs", "4 Parallel VMs - 2 NICs", "4 Parallel VMs - 4 NICs")) +
  theme_bw(base_size=12) +
  #scale_y_continuous(expand = c(0, 0), limits = c(0, 2.1), breaks = seq(0, 2  , by = 1)) +
  theme(legend.position = "top",
        legend.key = element_rect(fill = "black"),
        legend.key.height = unit(0.5, "line"),
        legend.key.width = unit(2, "line"),
        legend.spacing = unit(100, "line"),
        plot.margin = unit(x = c(0.2, 0.1, -0.2, 0), units = "cm"),
        legend.margin=margin(c(-2, 0, -10, 0)),
        axis.text.x = element_text(color = "black", size=12),
        axis.text.y = element_text(color = "black", size=12),
        axis.title=element_text(size=12, color = "black"), 
        legend.title = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.border = element_rect(color = "black", size=0.8),
        legend.text = element_text(color = "black", size=12)) +
        scale_x_discrete(labels=try) +
        labs(y=element_blank(),
        #x=element_blank()) 