##############################
#########  ANALYSIS ##########
##############################

#---------------------------------------------------------

# - PURPOSE: META-ANALYSIS 
# - AUTHOR: S. DICKSON
# - CONTRIBUTIONS: DR. P. LUGTIG, DR. B. STRUMINSKAYA

#---------------------------------------------------------

# import the libraries and the data: 
library(dplyr)
library(magrittr)
library(qgraph)
library(mgm)
library(devtools)
library(CatEncoders)

data <- readRDS("data/data_clean.RDS")
data_f2f <- readRDS("data/data_f2f.RDS")
data_mail <- readRDS("data/data_mai.RDSl")
data_web <- readRDS("data/data_web.RDS")
data_paper <- readRDS("data/data_paper.RDS")
data_tel <- readRDS("data/data_tel.RDS")


# reduce vars
data_all <- data_coded %>% select(AbsRelbias, MN, NQuestions, Incentivised, Reminder, Saliency, Sponsorship, SSize, Topic_Health, Mode)
f2f_net <- data_f2f_enc %>% select(AbsRelbias, MN, NQuestions, Incentivised, Reminder, Saliency, Sponsorship, SSize, Topic_Health)
mail_net <- data_mail_enc %>% select(AbsRelbias, MN, NQuestions, Incentivised, Reminder, Saliency, Sponsorship, SSize, Topic_Health)
web_net <- data_web_enc %>%  select(AbsRelbias, MN, NQuestions, Incentivised, Reminder, Saliency, Sponsorship, SSize, Topic_Health)
tel_net <- data_tel_enc %>% select(AbsRelbias, MN, Saliency, NQuestions, Topic_Health, Incentivised, Reminder, Nreminder, Urban, Prenotification)
paper_net <- data_paper_enc %>% select(AbsRelbias, MN, Saliency, NQuestions, Topic_Health, Incentivised, Reminder, Nreminder, Urban, Prenotification)

# omit NA
is.na(data_all) <- sapply(data_all, is.infinite)

is.na(f2f_net) <- sapply(f2f_net, is.infinite)
is.na(mail_net) <- sapply(mail_net, is.infinite)
is.na(web_net) <- sapply(web_net, is.infinite)
is.na(tel_net) <- sapply(tel_net, is.infinite)
is.na(paper_net) <- sapply(paper_net, is.infinite)

data_all <- na.omit(data_all)
f2f_net <- na.omit(f2f_net)
mail_net <- na.omit(mail_net)
web_net <- na.omit(web_net)
tel_net <- na.omit(tel_net)
paper_net <- na.omit(paper_net)

# make type and level labels
type <- c("g", "g", "g", "c", "c", "c", "c", "g", "c", "c")
levels <- c(1, 1, 1, 2, 2, 2, 2, 2, 1, 2, 5)

# make data list
data_net_list <- list(data = data_all, type = type, level = levels)
f2f_net_list <- list(data = f2f_net, type = type, level = levels)
web_net_list <- list(data = web_net, type = type, level = levels)
paper_net_list <- list(data = paper_net, type = type, level = levels)
mail_net_list <- list(data = mail_net, type = type, level = levels)
tel_net_list <- list(data = tel_net, type = type, level = levels)

# mixed graphical network model
f2f_net
mgm_f2f <- mgm(data = as.matrix(f2f_net_list$data), 
               type = f2f_net_list$type,
               level = f2f_net_list$levels,
               k = 2,
               lambdaSel = "CV",
               lambdaFolds = 10,
               pbar = FALSE)

# draw network
nnames<-colnames(data_all)
qgraph(input = mgm_all$pairwise$wadj,
       layout = 'circle',
       edge.color = mgm_f2f$pairwise$edgecolor,
       nodeNames = nnames,
       legend.cex=.45)

mgm_all <- mgm(data = as.matrix(data_net_list$data), 
               type = data_net_list$type,
               level = data_net_list$levels,
               k = 2,
               lambdaSel = "CV",
               lambdaFolds = 10,
               pbar = FALSE)

# draw network
nnames<-colnames(data_all)
qgraph(input = data_net_list$pairwise$wadj,
       layout = 'circle',
       edge.color = data_net_list$pairwise$edgecolor,
       nodeNames = nnames,
       legend.cex=.45)

# 
mgm_web <- mgm(data = as.matrix(web_net_list$data), 
               type = web_net_list$type,
               level = web_net_list$levels,
               k = 2,
               lambdaSel = "CV",
               lambdaFolds = 10,
               pbar = FALSE)

# draw network
nnames<-colnames(web_net)
qgraph(input = mgm_web$pairwise$wadj,
       layout = 'circle',
       edge.color = mgm_web$pairwise$edgecolor,
       nodeNames = nnames,
       legend.cex=.45)

# 
mgm_mail <- mgm(data = as.matrix(mail_net_list$data), 
               type = mail_net_list$type,
               level = mail_net_list$levels,
               k = 2,
               lambdaSel = "CV",
               lambdaFolds = 10,
               pbar = FALSE)

# draw network
nnames<-colnames(tel_net)
qgraph(input = tel_net_list$pairwise$wadj,
       layout = 'circle',
       edge.color = tel_net_list$pairwise$edgecolor,
       nodeNames = nnames,
       legend.cex=.45)
