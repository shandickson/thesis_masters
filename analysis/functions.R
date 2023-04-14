#----------------------------------------------------------------------------------------------
# FUNCTIONS 
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# This script contains all of the functions that I created for my thesis analysis.
# The following scripts in the repository depend on this script:
# - clean_data.R
# - descriptives.R
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# Author: Shannon Dickson
#----------------------------------------------------------------------------------------------
library(dplyr)
library(kableExtra)
#----------------------------------------------------------------------------------------------
# 1.1. This function performs the following data cleaning steps:
#      - Removes all leading and trailing whitespace
#      - Converts all character vars to factor vars
#      - Converts all double vars to numeric vars 

# SoF
cleanup    <- function(df, exclude = c()){
  df_clean <- df
  
  for (cols in names(df_clean)){
    if (!cols %in% exclude){
      col <- df_clean[[cols]]
      
      if (is.character(col)){
        col <- gsub("^[0-9]+\\.\\s+", "", col)
        
        col <- factor(col)
      }
      else if (is.double(col)){
        col <- as.numeric(col)
      }
      
      df_clean[[cols]] <- col
    }
  }
  return(df_clean)
}
# EoF

#----------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------
# 1.2. This function does some hack wrangling so that `mgm` manages the data correctly.
#      It takes 3 arguments: a) data,
#                            b) variables to exclude,
#                            c) option to remove levels from final results
#      The following steps are performed:
#      - Identify factor variables to be recoded as integers
#      - Order the data alphabetically so that no/yes variables are always recode 0/1
#      - Store the original factor "levels" so we can always check what the integers mean
#      - Finally, convert the factor vars to integer vars - 1 to start recoding from 0
#      - Store the factor levels as attributes in the dataset
#      - Remove the levels/attributes if the user requests this (so `mgm` runs)
#      - Return the data frame that is recoded including or excluding attributes

# SoF
map_values    <- function(data,
                          exclude = NULL,
                          remove_levels = FALSE) {
  
  factor_vars <- sapply(data, is.factor)
  
  if (!is.null(exclude)){
    factor_vars[exclude] <- FALSE
    }
  
  data            <- data[order(do.call(paste, data)),]
  original_levels <- lapply(data[factor_vars], levels)
  
  data[factor_vars]          <- lapply(data[factor_vars], function(x){
    x_as_int                 <- as.integer(x) - 1
    attr(x_as_int, "levels") <- levels(x)
    x_as_int
    })
  
  if (remove_levels) {
    for (i in which(factor_vars)){
      levels(data[[i]]) <- NULL
    }
    original_levels     <- NULL
    }
  
  if (remove_levels){
    return(data)
  }
  else{
    return(list(data            = data,
                original_levels = original_levels))
  }
  
}
# EoF
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# 1.3 This function gets the proportions of a variable by a grouping variable. 
#     The following steps are performed:
#     - the function takes three arguments: data, a grouping variable, and variable for %s
#     - missing values are dropped from the variables, before
#     - the outcome is grouped by the grouping variable
#     - a new prop column is calculated - the %s
#     - before results are pivoted to a wide format for better presentation
get_props <- function(data, grp, var) {
  data %>%
    drop_na({{grp}}, {{var}}) %>%
    count({{grp}}, {{var}}) %>%
    group_by({{grp}}) %>%
    mutate(prop = n / sum(n) * 100) %>%
    select(-n) %>%
    pivot_wider(names_from = {{var}}, values_from = prop)
}
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# 1.4 This function calculates the mean and SD from the mean
#     This is used when I generate violin plots. 
data_summary <- function(x) {
  m <- mean(x)
  ymin <- m-sd(x)
  ymax <- m+sd(x)
  return(c(y=m,ymin=ymin,ymax=ymax))
}
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------