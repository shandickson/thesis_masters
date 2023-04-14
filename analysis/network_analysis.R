##############################
#########  ANALYSIS ##########
##############################

#---------------------------------------------------------

# - PURPOSE: META-ANALYSIS 
# - AUTHOR: S. DICKSON
# - CONTRIBUTIONS: DR. P. LUGTIG

#---------------------------------------------------------

# import the libraries and the data: 
library(dplyr)
library(magrittr)
library(lme4)
library(lmerTest)
library(qgraph)
library(mgm)


# mixed graphical network model
data <- readRDS("data/data_clean.RDS")
data_short <- data %>% select(Mode, Saliency, Source, AbsRelbias, MN)
#data_short2 <- data %>% select(Saliency,MN, AbsRelbias) 
data_short$Mode <- plyr::mapvalues(data_short$Mode, from = c("F2F", "Web", "Mail", "Telephone", "Paper drop"), to = c("1", "2", "3", "4", "5"))
data_short$Saliency <- plyr::mapvalues(data_short$Saliency, from = c("Omnibus/Undetermined", "Yes", "No"), to = c("2", "1", "2"))
data_short$Source <- plyr::mapvalues(data_short$Source, from = c("Follow up", "Frame", "Intention to respond", "Screener", "Supplemental"), to = c("1", "2", "3", "4", "5"))
#data_short$Topic <- plyr::mapvalues(data_short$Topic, from = c("Health", "Consumer satisfaction", "Crime", " Education", " Employment", "Finances","General attitudes","Living", "Omnibus", "Parenthood", "Safety", "Special interests", "Travel", "Voting"), to = c("1", "2", "6", "6", "3", "6", "4", "5", "6", "6", "6", "6", "6", "6"))

type <- c("c", "c", "c", "g", "g")
level <- c(5, 2, 5, 1, 1)

#type <- c("c", "g", "g")
#level <- c(2, 1, 1 )

data_short <- data_short %>% mutate_if(is.double, as.numeric) %>%  mutate_if(is.factor, as.integer)
is.na(data_short) <- sapply(data_short, is.infinite)
data_short<-na.omit(data_short)
data_short_list<-list(data = data_short, type = type, level = level)
data_short_list$type
data_short_list$level

set.seed(1234)

mgm_obj <- mgm(data = data_short_list$data, 
               type = data_short_list$type,
               level = data_short_list$level,
               k = 2,
               lambdaSel = "CV",
               lambdaFolds = 10,
               pbar = FALSE)

nnames<-colnames(data_short)
qgraph(input = mgm_obj$pairwise$wadj,
       layout = 'circle',
       edge.color = mgm_obj$pairwise$edgecolor,
       nodeNames = nnames,
       legend.cex=.45)

# CONTINUOUS-CONTINUOUS INTERACTIONS:

# - interaction between nonresponse and bias
showInteraction(object = mgm_obj, 
                int = c(1,2))

 # CATEGORICAL-CATEGORICAL INTERACTIONS:

# - interaction between mode and topic
showInteraction(object = mgm_obj, 
                int = c(1, 2))
# - interaction between mode and source
showInteraction(object = mgm_obj, 
                int = c(1, 4))
# - interaction between mode and saliency
showInteraction(object = mgm_obj, 
                int = c(1, 3))
# - interaction between topic and source
showInteraction(object = mgm_obj, 
                int = c(2, 4))
# - interaction between topic and saliency
showInteraction(object = mgm_obj, 
                int = c(2, 3))

# CONTINUOUS-CATEGORICAL INTERACTIONS

# - interaction between topic and bias
showInteraction(object = mgm_obj, 
                int = c(2, 5))
# - interaction between topic and nonresponse
showInteraction(object = mgm_obj, 
                int = c(2, 6))
# - interaction between mode and nonresponse
showInteraction(object = mgm_obj, 
                int = c(1, 6))
# - interaction between source and nonresponse
showInteraction(object = mgm_obj, 
                int = c(4, 6))

mgm_obj$interactions

exp(.12)
.63/.58

  