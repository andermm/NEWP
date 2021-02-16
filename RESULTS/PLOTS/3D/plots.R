options(crayon.enabled=FALSE)
library("tidyverse")
library("ggplot2")
library("patternplot")

# 4 intancias nativo
df_apps_nativo_4inst <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/native-4instanc/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + 3 Concurrent (4 Instances)", df_apps_nativo_4inst) -> df_apps_nativo_4inst
df_apps_nativo_4inst$apps=toupper(df_apps_nativo_4inst$apps)

# 2 intancias nativo
df_apps_nativo_2inst <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/native-2instanc/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + 1 Concurrent (2 Instances)", df_apps_nativo_2inst) -> df_apps_nativo_2inst
df_apps_nativo_2inst$apps=toupper(df_apps_nativo_2inst$apps)

# 1 instancias nativo
df_apps_nativo_1inst <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/native-1instanc/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + No Concurrent (1 Instance)", df_apps_nativo_1inst) -> df_apps_nativo_1inst
df_apps_nativo_1inst$apps=toupper(df_apps_nativo_1inst$apps)

# 4 placas agregadas 802.3ad
df_apps_4NICs_802.3ad_layer2_1_64_SP_BT1 <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/802.3ad-4NICs-layer2-1/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + No Concurrent (1 Instance)", df_apps_4NICs_802.3ad_layer2_1_64_SP_BT1) -> df_apps_4NICs_802.3ad_layer2_1_64_SP_BT1
df_apps_4NICs_802.3ad_layer2_1_64_SP_BT1$apps=toupper(df_apps_4NICs_802.3ad_layer2_1_64_SP_BT1$apps)

df_apps_4NICs_802.3ad_layer2_2_64_SP_BT1 <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/802.3ad-4NICs-layer2-2/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + 1 Concurrent (2 Instances)", df_apps_4NICs_802.3ad_layer2_2_64_SP_BT1) -> df_apps_4NICs_802.3ad_layer2_2_64_SP_BT1
df_apps_4NICs_802.3ad_layer2_2_64_SP_BT1$apps=toupper(df_apps_4NICs_802.3ad_layer2_2_64_SP_BT1$apps)

df_apps_4NICs_802.3ad_layer2_4_64_SP_BT1 <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/802.3ad-4NICs-layer2-4/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + 3 Concurrent (4 Instances)", df_apps_4NICs_802.3ad_layer2_4_64_SP_BT1) -> df_apps_4NICs_802.3ad_layer2_4_64_SP_BT1
df_apps_4NICs_802.3ad_layer2_4_64_SP_BT1$apps=toupper(df_apps_4NICs_802.3ad_layer2_4_64_SP_BT1$apps)

# 2 placas agregadas 802.3ad
df_apps_2NICs_802.3ad_layer2_1_64_SP_BT1 <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/802.3ad-2NICs-layer2-1/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + No Concurrent (1 Instance)", df_apps_2NICs_802.3ad_layer2_1_64_SP_BT1) -> df_apps_2NICs_802.3ad_layer2_1_64_SP_BT1
df_apps_2NICs_802.3ad_layer2_1_64_SP_BT1$apps=toupper(df_apps_2NICs_802.3ad_layer2_1_64_SP_BT1$apps)

df_apps_2NICs_802.3ad_layer2_2_64_SP_BT1 <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/802.3ad-2NICs-layer2-2/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + 1 Concurrent (2 Instances)", df_apps_2NICs_802.3ad_layer2_2_64_SP_BT1) -> df_apps_2NICs_802.3ad_layer2_2_64_SP_BT1
df_apps_2NICs_802.3ad_layer2_2_64_SP_BT1$apps=toupper(df_apps_2NICs_802.3ad_layer2_2_64_SP_BT1$apps)

df_apps_2NICs_802.3ad_layer2_4_64_SP_BT1 <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/802.3ad-2NICs-layer2-4/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + 3 Concurrent (4 Instances)", df_apps_2NICs_802.3ad_layer2_4_64_SP_BT1) -> df_apps_2NICs_802.3ad_layer2_4_64_SP_BT1
df_apps_2NICs_802.3ad_layer2_4_64_SP_BT1$apps=toupper(df_apps_2NICs_802.3ad_layer2_4_64_SP_BT1$apps)

# 2 placas agregadas RR
df_apps_2NICs_rr_layer2_1_64_SP_BT1 <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/rr-2NICs-layer2-1/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + No Concurrent (1 Instance)", df_apps_2NICs_rr_layer2_1_64_SP_BT1) -> df_apps_2NICs_rr_layer2_1_64_SP_BT1
df_apps_2NICs_rr_layer2_1_64_SP_BT1$apps=toupper(df_apps_2NICs_rr_layer2_1_64_SP_BT1$apps)

df_apps_2NICs_rr_layer2_2_64_SP_BT1 <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/rr-2NICs-layer2-2/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + 1 Concurrent (2 Instances)", df_apps_2NICs_rr_layer2_2_64_SP_BT1) -> df_apps_2NICs_rr_layer2_2_64_SP_BT1
df_apps_2NICs_rr_layer2_2_64_SP_BT1$apps=toupper(df_apps_2NICs_rr_layer2_2_64_SP_BT1$apps)

df_apps_2NICs_rr_layer2_4_64_SP_BT1 <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/rr-2NICs-layer2-4/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + 3 Concurrent (4 Instances)", df_apps_2NICs_rr_layer2_4_64_SP_BT1) -> df_apps_2NICs_rr_layer2_4_64_SP_BT1
df_apps_2NICs_rr_layer2_4_64_SP_BT1$apps=toupper(df_apps_2NICs_rr_layer2_4_64_SP_BT1$apps)

# 2 placas agregadas RR
df_apps_4NICs_rr_layer2_1_64_SP_BT1 <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/rr-4NICs-layer2-1/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + No Concurrent (1 Instance)", df_apps_4NICs_rr_layer2_1_64_SP_BT1) -> df_apps_4NICs_rr_layer2_1_64_SP_BT1
df_apps_4NICs_rr_layer2_1_64_SP_BT1$apps=toupper(df_apps_4NICs_rr_layer2_1_64_SP_BT1$apps)

df_apps_4NICs_rr_layer2_2_64_SP_BT1 <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/rr-4NICs-layer2-2/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + 1 Concurrent (2 Instances)", df_apps_4NICs_rr_layer2_2_64_SP_BT1) -> df_apps_4NICs_rr_layer2_2_64_SP_BT1
df_apps_4NICs_rr_layer2_2_64_SP_BT1$apps=toupper(df_apps_4NICs_rr_layer2_2_64_SP_BT1$apps)

df_apps_4NICs_rr_layer2_4_64_SP_BT1 <- read_csv("/home/mrneverdie/Git/NEWP/RESULTS/rr-4NICs-layer2-4/LOGS/SP-BT-64.csv", progress=FALSE)
data.frame(conc="1 Main + 3 Concurrent (4 Instances)", df_apps_4NICs_rr_layer2_4_64_SP_BT1) -> df_apps_4NICs_rr_layer2_4_64_SP_BT1
df_apps_4NICs_rr_layer2_4_64_SP_BT1$apps=toupper(df_apps_4NICs_rr_layer2_4_64_SP_BT1$apps)

###############################################################################
df_apps=bind_rows(
  df_apps_nativo_4inst, df_apps_nativo_2inst, df_apps_nativo_1inst, df_apps_4NICs_802.3ad_layer2_1_64_SP_BT1, df_apps_2NICs_802.3ad_layer2_1_64_SP_BT1, df_apps_2NICs_rr_layer2_1_64_SP_BT1, df_apps_4NICs_rr_layer2_1_64_SP_BT1
  ,df_apps_4NICs_802.3ad_layer2_2_64_SP_BT1, df_apps_2NICs_802.3ad_layer2_2_64_SP_BT1, df_apps_2NICs_rr_layer2_2_64_SP_BT1, df_apps_4NICs_rr_layer2_2_64_SP_BT1
  ,df_apps_4NICs_802.3ad_layer2_4_64_SP_BT1, df_apps_2NICs_802.3ad_layer2_4_64_SP_BT1, df_apps_2NICs_rr_layer2_4_64_SP_BT1, df_apps_4NICs_rr_layer2_4_64_SP_BT1)
df_apps$apps=toupper(df_apps$apps)

df_apps %>%
  group_by(conc,apps,bondmode) %>%
  summarise(
    average=mean(time),
    std=sd(time),
    ste=3*std/sqrt(n()),
    N=n()) %>%
  arrange(conc,apps,bondmode) -> df_apps
df_apps

try <- c("802.3ad-4NICs-layer2-4"="4-4", "802.3ad-2NICs-layer2-4"="4-2", "balance-rr-4NICs-layer2-4"="0-4", "balance-rr-2NICs-layer2-4"="0-2", "native-4instance"="None", 
         "802.3ad-4NICs-layer2-2"="4-4", "802.3ad-2NICs-layer2-2"="4-2", "balance-rr-4NICs-layer2-2"="0-4", "balance-rr-2NICs-layer2-2"="0-2", "native-2instance"="None",
         "802.3ad-4NICs-layer2-1"="4-4", "802.3ad-2NICs-layer2-1"="4-2", "balance-rr-4NICs-layer2-1"="0-4", "balance-rr-2NICs-layer2-1"="0-2", "native-1instance"="None")

order <- c("802.3ad-4NICs-layer2-4", "802.3ad-2NICs-layer2-4", "native-4instance", "balance-rr-4NICs-layer2-4", "balance-rr-2NICs-layer2-4", 
           "802.3ad-4NICs-layer2-2", "802.3ad-2NICs-layer2-2", "native-2instance", "balance-rr-4NICs-layer2-2", "balance-rr-2NICs-layer2-2",
           "802.3ad-4NICs-layer2-1", "802.3ad-2NICs-layer2-1", "native-1instance", "balance-rr-4NICs-layer2-1", "balance-rr-2NICs-layer2-1")

ggplot(df_apps, aes(x=factor(bondmode, level=order), y= round(average, digits = 2) , fill=bondmode)) +
  geom_bar(stat="identity", position = "dodge",  colour="black",size=0.2,width = 0.7) +
  geom_errorbar(aes(ymin=average-ste, ymax=average+ste), width=0.3, position = position_dodge(1)) +
  geom_text(aes(label = sprintf("%0.2f", round(average, digits = 2))), size = 3.5, position = position_stack(vjust = 0.5), angle=90) +
  theme_bw(base_size=12) +
  scale_fill_manual(values=c("#969696", "#969696", "#969696", "#636363", "#636363",
                             "#636363", "#f7f7f7", "#f7f7f7", "#f7f7f7", "#d9d9d9",
                             "#d9d9d9", "#d9d9d9", "#bdbdbd", "#bdbdbd", "#bdbdbd"),
                    breaks=c("802.3ad-4NICs-layer2-4", "802.3ad-2NICs-layer2-4", "native-4instance", "balance-rr-4NICs-layer2-4", "balance-rr-2NICs-layer2-4"),
                    labels=c("Mode 4 (802.3ad) with 4 NICs", "Mode 4 (802.3ad) with 2 NICs", "Native", "Mode 0 (RR) with 4 NICs", "Mode 0 (RR) with 2 NICs")) +
  facet_wrap(~conc, scales="free_x") +
  theme(strip.text.x=element_text(size=9.8), strip.background=element_rect(fill='#F5F5F5')) +
  scale_x_discrete(labels=try) +
  scale_y_continuous(expand = c(0.01, 0)) +
  theme(legend.position = c(0.837, 0.8),
        legend.background = element_blank(),
        #legend.key.height=unit(0.5, "cm"),
        plot.margin = unit(x = c(0.1, 0.1, 0, 0), units = "cm"),
        legend.margin=margin(c(0, 0, -8, 0)),
        axis.text.x = element_text(color = "black"),
        axis.text.y = element_text(color = "black"),
        axis.title=element_text(size=12), 
        legend.title = element_blank(),
        legend.text = element_text(color = "black", size = 10)) +
  labs(y="SP-BT Execution Time [s]",
       x="Aggregation Mode")
ggsave("/home/mrneverdie/Git/NEWP/RESULTS/PLOTS/3D/SP-BT-64.png", dpi = 300)
