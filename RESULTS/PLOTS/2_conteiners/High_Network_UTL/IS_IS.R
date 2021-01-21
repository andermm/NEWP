options(crayon.enabled=FALSE)
suppressMessages(library("tidyverse"));

df_apps_4NICs_LACP <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/802.3ad-4NICs-layer2-2/LOGS/IS-IS-64.csv", progress=FALSE)
data.frame(conc="LACP_4", df_apps_4NICs_LACP) -> df_apps_4NICs_LACP
df_apps_4NICs_LACP$apps=toupper(df_apps_4NICs_LACP$apps)

df_apps_2NICs_LACP <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/802.3ad-2NICs-layer2-2/LOGS/IS-IS-64.csv", progress=FALSE)
data.frame(conc="LACP_2", df_apps_2NICs_LACP) -> df_apps_2NICs_LACP
df_apps_2NICs_LACP$apps=toupper(df_apps_2NICs_LACP$apps)

df_apps_native <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/native-2instanc/LOGS/IS-IS-64.csv", progress=FALSE)
data.frame(conc="Native",  df_apps_native) ->  df_apps_native
df_apps_native$apps=toupper( df_apps_native$apps)

df_apps_2NICs_RR <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/rr-2NICs-layer2-2/LOGS/IS-IS-64.csv", progress=FALSE)
data.frame(conc="RR_2", df_apps_2NICs_RR) -> df_apps_2NICs_RR
df_apps_2NICs_RR$apps=toupper(df_apps_2NICs_RR$apps)

df_apps_4NICs_RR <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/rr-4NICs-layer2-2/LOGS/IS-IS-64.csv", progress=FALSE)
data.frame(conc="RR_4", df_apps_4NICs_RR) -> df_apps_4NICs_RR
df_apps_4NICs_RR$apps=toupper(df_apps_4NICs_RR$apps)


df_apps=bind_rows(df_apps_4NICs_LACP,  df_apps_2NICs_LACP, df_apps_native, df_apps_2NICs_RR, df_apps_4NICs_RR)
df_apps$apps=toupper(df_apps$apps)

df_apps %>%
  group_by(conc,apps) %>%
  summarise(
    average=mean(time),
    std=sd(time),
    ste=3*std/sqrt(n()),
    N=n()) %>%
  arrange(conc,apps) -> df_apps
df_apps


df_apps$conc <- factor(df_apps$conc)
ggplot(df_apps, aes(x=conc, y=average, fill=conc)) +
  geom_bar(stat="identity", position = "dodge",  colour="black",size=0.1,width = 0.5) +
  geom_errorbar(aes(ymin=average-ste, ymax=average+ste), width=0.2, position = position_dodge(1)) +
  theme_bw(base_size=10) +
  scale_fill_manual(values=c("#a3a3a3", "#cccccc", "#43454b", "#eeeeee", "#ffffff"),
                    breaks=c("LACP_4", "LACP_2", "Native", "RR_2", "RR_4"),
                    labels=c("LACP_4", "LACP_2", "Native", "RR_2", "RR_4")) +
  theme(legend.position = "none", 
        plot.margin = unit(x = c(0.1, 0.1, -0.2, 0), units = "cm"),
        legend.margin=margin(c(0, 0, -8, 0)),
        axis.text.x = element_text(color = "black"),
        axis.text.y = element_text(color = "black"),
        axis.title=element_text(size=10), 
        legend.title = element_blank(),
        legend.text = element_text(color = "black", size = 10)) +
  labs(y="Execution Time [s]",
       x=element_blank())

