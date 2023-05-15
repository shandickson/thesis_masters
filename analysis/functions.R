#----------------------------------------------------------------------------------------------
# FUNCTIONS 
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# This script contains all of the functions that I created for my thesis analysis.
# The following scripts in the repository depend on this script:
# - data_preparation.Rmd
# - data_descriptives.Rmd
# - data_networks.Rmd
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# Author: Shannon Dickson
#----------------------------------------------------------------------------------------------
library(dplyr)
library(kableExtra)
source("plot_theme.R")
#----------------------------------------------------------------------------------------------
# 1.1. This function performs the following data cleaning steps:
#      - Removes all leading and trailing whitespace
#      - Converts all character vars to factor vars
#      - Converts all double vars to numeric vars 
#      It takes two arguments:
#      - df, a dataframe to be cleaned
#      - exclude, any variables to be excluded from the operation
cleanup    <- function(df, exclude = c()){
  
  df_clean <- df
  
  # iterate over the columns, skipping the exclusions
  for (cols in names(df_clean)){
    if (!cols %in% exclude){
      col <- df_clean[[cols]]
      
      # remove numbering and whitespace before factor levels
      if (is.character(col)){
        col <- gsub("^[0-9]+\\.\\s+", "", col)
        
        col <- factor(col)
      }
      else if (is.double(col)){
        col <- as.numeric(col)
      }
      # replace the old columns with clean columns
      df_clean[[cols]] <- col
    }
  }
  return(df_clean)
}
# EoF

#----------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------
# 1.2. This function does some hack wrangling so that `mgm` manages the data correctly.
#      It takes 3 arguments: - data,
#                            - variables to exclude,
#                            - option to remove levels from final results
#      The following steps are performed:
#      - Identify factor variables to be recoded as integers
#      - Order the data alphabetically so that no/yes variables are always recode 0/1
#      - Store the original factor "levels" so we can always check what the integers mean
#      - Finally, convert the factor vars to integer vars - 1 to start recoding from 0
#      - Store the factor levels as attributes in the dataset
#      - Remove the levels/attributes if the user requests this (so `mgm` runs)
#      - Return the data frame that is recoded including or excluding attributes

map_values    <- function(data,
                          exclude = NULL,
                          remove_levels = FALSE) {
  
  # make sure all variables are factors first
  factor_vars <- sapply(data, is.factor)
  
  if (!is.null(exclude)){
    factor_vars[exclude] <- FALSE
  }
  
  # sort the rows then store the original factor levels for safekeeping
  data            <- data[order(do.call(paste, data)),]
  original_levels <- lapply(data[factor_vars], levels)
  
  # recode the factor levels to be integers startin from 0
  data[factor_vars]          <- lapply(data[factor_vars], function(x){
    x_as_int                 <- as.integer(x) - 1
    attr(x_as_int, "levels") <- levels(x)
    x_as_int
  })
  
  # should the original factor levels be discarded or not
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
    
    count({{grp}},   {{var}}) %>%
    
    group_by({{grp}}) %>%
    
    mutate(prop = n / sum(n) * 100) %>%
    
    select(-n) %>%
    
    pivot_wider(names_from = {{var}}, values_from = prop)
}

# EoF
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# 1.4 This function calculates the mean and SD from the mean
#     This is used when I generate violin plots. 

data_summary <- function(x) {
  
  m    <- mean(x)
  
  ymin <- m-sd(x)
  
  ymax <- m+sd(x)
  
  return(c(y = m, ymin = ymin, ymax = ymax))
  
}

# EoF
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# 1.5 This function is used in the manuscript as a replacement for the collapse_rows function
#     from the kableExtra package, since the original function is no longer working. 
#     It takes 2 input arguments:
#     - df, a dataframe that has some rows you want to collapse
#     - variable, the grouping variable to collapse rows on

collapse_rows_df <- function(df, variable){
  
  group_var <- enquo(variable)
  
  df %>%
    
    group_by(!! group_var) %>%
    
    mutate(groupRow = 1:n()) %>%
    
    ungroup() %>%
    
    mutate(!!quo_name(group_var) := ifelse(groupRow == 1, as.character(!! group_var), "")) %>%
    
    select(-c(groupRow))
  
}

# EoF
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# 2.1 This function performs bootstrapping operations over a list of network objects
#     It is used to get the accuracy/stability of each network, taking 3 arguments:
#       a) dfs, a list of dataframes/objects
#       b) nB, the number of bootstrap iterations (default is 10)
#       c) nC, the number of parallel cores to use (default is 4)
#       d) which_boot, what type of bootstrap to perform (NP = nonparametric,
#          CD = casedropping, B = both)
#     The following steps are peformed:
#       - Lists are initialised to store the results
#       - Column names are created to format the output nicely
#       - A series of if else conditions that perform the correct bootstrap,
#         iterating over each dataframe given by the user.
#       - Results are returned, with the nonparametric and case-dropping bootstrap
#         returned in a list together if both are requested. 

do_stability <- function(dfs, nB = 10, nC = 4, which_boot = c("NP", "CD", "B")) {
  
  # storage
  boots      <- list()
  boots_cd   <- list()
  boots_np   <- list()
  which_boot <- which_boot
  nB         <- nB
  nC         <- nC
  
  # arguments
  network_names <- c("overall_boot", "f2f_boot", "mail_boot", "web_boot", "tel_boot")
  boot_names    <- c("nonparametric", "case")
  
  # start nonparametric bootstrap
  if(which_boot == "NP") {
    
    # iterate over all mgms
    for(i in seq_along(dfs)) {
      
      # perform the bootstrap
      boots_np[[i]] <- bootnet::bootnet(data = dfs[[i]], nBoots = nB, nCores = nC, type = "nonparametric")
      
    }
    
    # add nice network names
    names(boots_np) <- network_names
    
    return(boots_np)
    
    # start the casedropping bootstrap
  } else if(which_boot == "CD") {
    
    # iterate over all mgms
    for(i in seq_along(dfs)) {
      
      # perform the bootstrap
      boots_cd[[i]] <- bootnet::bootnet(data = dfs[[i]], nBoots = nB, nCores = nC, type = "case")
      
    }
    
    # add nice network names
    names(boots_cd) <- network_names
    
    return(boots_cd)
    
    # else do both types of bootstrap (currently not well supported)
  } else {
    
    for(i in seq_along(dfs)) {
      
      boots_cd[[i]] <- bootnet::bootnet(data = dfs[[i]], nBoots = nB, nCores = nC, type = "case")
      boots_np[[i]] <- bootnet::bootnet(data = dfs[[i]], nBoots = nB, nCores = nC, type = "nonparametric")
      
    }
    
    names(boots_cd) <- network_names
    names(boots_np) <- network_names
    
    boots <- list(boots_cd, boots_np)
    
    names(boots) <- boot_names
    
    return(boots)
  }
  
}

# EoF
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# 2.2 The two functions below take a list of plot objects and arranges them nicely using ggpubr::ggarrange
#     It is used inside the plot_stability function. It takes two input arguments:
#     - a list of plots
#     - a logical panels indicating if you want ggarrange to put alphabetically labelled panels
#     - note that this function assumes the input list is of length 5

# start edge accuracy plots
make_edge_plots <- function(list, panels = TRUE){
  
  # should panels be labelled
  panels <- panels
  
  if(panels == TRUE){
  
  # list the plots
  a <- list[[1]] 
  b <- list[[2]]
  c <- list[[3]]
  d <- list[[4]]
  e <- list[[5]]
  
  # arrange
  ggpubr::ggarrange(a, b, c, d, e, ncol = 2, nrow = 3, labels = c("A", "B", "C", "D", "E"), legend = "top")
  
  } else if(panels == FALSE){ 
      
     # list the plots, no panel labels
      a <- list[[1]] 
      b <- list[[2]]
      c <- list[[3]]
      d <- list[[4]]
      e <- list[[5]]
      
      # arrange
      ggpubr::ggarrange(a, b, c, d, e, ncol = 2, nrow = 3, common.legend = TRUE, legend = "top") 

  }
  
}

# start strength stability plots
make_strength_plots <- function(list, panels = TRUE, legend){
  
  panels <- panels
  legend <- legend
  
  if(panels == TRUE){
    
    a <- list[[1]] 
    b <- list[[2]]
    c <- list[[3]]
    d <- list[[4]]
    e <- list[[5]]
    
    ggpubr::ggarrange(a, b, c, d, e, ncol = 2, nrow = 3, labels = c("A", "B", "C", "D", "E"), legend = legend)  %>% ggpubr::annotate_figure(left = grid::textGrob("Average correlation with original sample", rot = 90),
                                                                                                                                           bottom = grid::textGrob("Sampled cases"))
    
  } else if(panels == FALSE){ 
    
    a <- list[[1]] 
    b <- list[[2]]
    c <- list[[3]]
    d <- list[[4]]
    e <- list[[5]]
    
    ggpubr::ggarrange(a, b, c, d, e, ncol = 2, nrow = 3, legend = legend)  %>% ggpubr::annotate_figure(left = grid::textGrob("Average correlation with original sample", rot = 90),
                                                                                                                            bottom = grid::textGrob("Sampled cases"))
    
  }
  
}
# EoF
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# 2.2 This function creates the correct type of plot for the bootstrap samples. Taking arguments:
#     - a list of dataframes with the results of the bootstrap procedure
#     - which_boot to indicate if a nonparametric (NP) or casedropping (CD) bootstrap is wanted
#     - which_plot to indicate if the resulting plot should be accuracy (for edges),
#       difference, or stability (for centrality)
#     - logical labels, panels, and legends are plot parameters for including axis labels,
#       panel numbering, and legends

plot_stability <- function(list, which_boot = c("NP", "CD"), which_plot = c("accuracy", "difference", "stability"), labels = TRUE, panels = TRUE, legend) {
   
  # arguments                   
  legend               <- legend          
  labels               <- labels
  panels               <- panels
  
  # storage
  edge_accuracy        <- list()
  edge_accuracy_split  <- list()
  edge_differences     <- list()
  
  strength_stability   <- list()
  strength_differences <- list()
  
  # if nonparametric bootstrap is performed for edge accuracy
  if(which_boot == "NP" & which_plot == "accuracy") {
    
    # iterate over the bootstrap results
    for(i in seq_along(boots_nonparametric)) {
      
      # plot edge accuracy
      edge_accuracy[[i]]       <- plot(boots_nonparametric[[i]], statistics = "edge", labels = labels, legend = FALSE, order = "sample", bootColor = "#386cb0", meanColor = "#386cb0", meanlwd = 1, bootlwd = 1, sampleColor = "#fec66b") + theme_thesis() 
                                                                                                                           
      # plot edge accuracy, split at 0 x-axis
      edge_accuracy_split[[i]] <- plot(boots_nonparametric[[i]], statistics = "edge", labels = labels, legend = FALSE, order = "sample", split0 = TRUE, bootColor = "#386cb0", meanColor = "#386cb0", meanlwd = 1, bootlwd = 1, sampleColor = "#fec66b") + theme_thesis() 
                                                                                                                                        
      
    }
    
    # gather the plots
    everything <- list(edge_accuracy, edge_accuracy_split)
    # arrange the plots
    get_plots  <- lapply(everything, make_edge_plots, panels = panels)
    
    # if nonparametric bootstrap is performed for edge or strength differences
  } else if(which_boot == "NP" & which_plot == "difference") {
    
    for(i in seq_along(boots_nonparametric)) {
      
      # plot
      edge_differences[[i]]     <- plot(boots_nonparametric[[i]], statistics = "edge",     plot = "difference", onlyNonZero = TRUE, order = "sample", labels = F)  
      strength_differences[[i]] <- plot(boots_nonparametric[[i]], statistics = "strength", plot = "difference", labels = labels)
      
    }
    
    # arrange
    everything <- list(edge_differences, strength_differences)
    get_plots  <- lapply(everything, make_edge_plots, panels = panels, legend = legend)
    
    # if casedropping bootstrap is performed for strength stability
  } else if(which_boot == "CD" & which_plot == "stability") {
    
    for(i in seq_along(boots_casedropping)) {
      
      # plot
      strength_stability[[i]]   <- plot(boots_casedropping[[i]], statistics = "all") +  theme_thesis() + scale_colour_thesis() + scale_fill_thesis() + theme(legend.position = "none", axis.title.y = element_blank(), axis.title.x = element_blank())
                                                                                   
      
    }
    # arrange
    get_plots  <- make_strength_plots(strength_stability, panels = panels, legend = legend)
    
  }
  
  # return the list of nice plots
  results <- list(edge_accuracy, edge_accuracy_split, edge_differences, strength_differences, strength_stability, get_plots)
  
  return(results)
  
}

# EoF
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# 2.3 This function collects all the interaction parameters from a network model to a list of dataframes.
#     It only has a row and column for the node levels that have non-zero interactions
#     (e.g., if there are no interactions between N1 and all other nodes there will be no N1 column)
#     It takes 3 input arguments:
#     - network, a network object that is output from `mgm`
#     - n_nodes, the number of nodes in the network, 
#     - separate, a logical indicatings if all results should be merged into one dataframe or not,
#       because there are two sets of parameters estimates in each direction of the relationship
#       between nodes (e.g., N1 -> N2 and N1 <- N2)

get_interactions <- function(network, n_nodes, separate = TRUE){
  
  # arguments and storage
  p               <- n_nodes
  ints_list       <- list()
  
  predict_1s <- list()
  predict_2s <- list()
  predicts   <- list()
  
  # for all node combinations
  for(i in 1:(p - 1)) {
    
    # that have not been seen before
    for(j in (i + 1):p) {
      
      # get the interactions of node i and node j
      ints <- showInteraction(object = network, int = c(i, j))$parameters
      # format how the list appears, for ease of understanding
      ints_list[[paste(i, j, sep = "_")]] <- ints
      
    }
    
  }
  
  # if we want separate dataframes for nodewise predictions
  if (separate == TRUE){
    
    for(i in seq_along(ints_list)) {
      
      # skip to the next iteration of the loop if no interaction
      if (length(ints_list[[i]]) == 0) {
        next  
      }
      
      # get the two matrices from the sublist
      tmp_1 <- ints_list[[i]][[1]]
      tmp_2 <- t(ints_list[[i]][[2]])
      
      tmp_3 <- as.data.frame(tmp_1)
      tmp_4 <- as.data.frame(tmp_2)
      
      # add the data frame to the list
      predict_1s[[i]] <- tmp_3
      predict_2s[[i]] <- tmp_4
      
    }
    
    result <- list(predict_1s = predict_1s, predict_2s = predict_2s)
    
    # if we want merged dataframes for nodewise predictions
  } else if (separate == FALSE) {
    
    for(i in seq_along(ints_list)) {
      
      # skip to the next iteration of the loop
      if (length(int_list[[i]]) == 0) {
        next  
      }
      
      # get the two matrices from the sublist
      tmp_1 <- ints_list[[i]][[1]]
      tmp_2 <- t(ints_list[[i]][[2]])
      
      tmp_3 <- as.data.frame(cbind(tmp_1, tmp_2))
      
      # add the data frame to the list
      predicts[[i]] <- tmp_3
      
      result <- predicts
      
    }
    
  }
  
  return(result) 
  
}

# EoF
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# 2.4 This function gets the merged parameter matrix, one for predictions in each direction.
#     It creates a consistent matrix format across all networks (i.e. same dimensions) such that
#     there is a row and column for each node regardless of whether there is non-zero parameter
#     It takes 3 input arguments:
#     - tinteractions, he list of interactions that is output from get_interactions
#     - n_nodes, the number of nodes in the corresponding network

merge_ints <- function(interactions, n_nodes) {
  
  # Get the row and column predictions from the previous function output
  predict_1s <- interactions$predict_1s
  predict_2s <- interactions$predict_2s
  
  # storage
  merged_predict_1s <- list()
  merged_predict_2s <- list()
  
  # Define row names based on the number of nodes
  if(n_nodes == 10){
    row_names = c("1", "2", "3","4.0", "4.1", "5.0", "5.1", "6.0", "6.1", "7.0", "7.1", "8.0", "8.1", "9.0", "9.1", "10.0", "10.1", "10.2")
  } else(
    row_names = c("1", "2", "3","4.0", "4.1", "5.0", "5.1", "6.0", "6.1", "7.0", "7.1", "8.0", "8.1", "9.0", "9.1", "10.0", "10.1", "10.2", "11.0", "11.1", "11.2", "11.3", "11.4"))
  
  # Iterate over each row name
  for(rn in row_names) {
    
    # Filter predict_1s and predict_2s based on whether the row name is present in the row names of each data frame
    sub_predict_1s <- predict_1s[sapply(predict_1s, function(df) rn %in% row.names(df))]
    sub_predict_2s <- predict_2s[sapply(predict_2s, function(df) rn %in% row.names(df))]
    
    if (length(sub_predict_1s) > 1) {
      
      # If there are multiple data frames in sub_predict_2s, merge them column-wise and store in merged_predict_2s
      merge_1s <- do.call(cbind, sub_predict_1s)
      merged_predict_1s[[as.character(rn)]] <- merge_1s
    }
    
    if (length(sub_predict_2s) > 1) {
      
      merge_2s <- do.call(cbind, sub_predict_2s)
      merged_predict_2s[[as.character(rn)]] <- merge_2s
      
    }
    
  }
  
  # Remove duplicates from merged_predict_1s and merged_predict_2s, keeping the last occurrence
  merged_predict_1s <- unique(merged_predict_1s, fromLast = TRUE)
  merged_predict_2s <- unique(merged_predict_2s, fromLast = TRUE)
  
  # Create empty result matrices with dimensions based on the row names
  matrix_predict_1s <- matrix(nrow = length(row_names), ncol = length(row_names), dimnames = list(row_names, row_names))
  matrix_predict_2s <- matrix(nrow = length(row_names), ncol = length(row_names), dimnames = list(row_names, row_names))
  
  for (df in merged_predict_1s) {
    # Check if any rows or columns in the dataframe match those in the result matrix
    rows_match <- rownames(df) %in% row_names
    cols_match <- colnames(df) %in% row_names
    
    if (any(rows_match) & any(cols_match)) {
      # Subset the result matrix to only include matching rows and columns
      subset_1s <- matrix_predict_1s[rownames(df)[rows_match], colnames(df)[cols_match]]
      
      # Subset the dataframe to only include matching rows and columns
      df_subset_1s <- df[rownames(subset_1s), colnames(subset_1s)]
      
      # Fill in the matching values from the dataframe to the result matrix
      matrix_predict_1s[rownames(df_subset_1s), colnames(df_subset_1s)] <- as.matrix(df_subset_1s)
      
    }
  }
  
  for (df in merged_predict_2s) {
    # Check if any rows or columns in the dataframe match those in the result matrix
    rows_match <- rownames(df) %in% row_names
    cols_match <- colnames(df) %in% row_names
    
    if (any(rows_match) & any(cols_match)) {
      # Subset the result matrix to only include matching rows and columns
      subset_2s <- matrix_predict_2s[rownames(df)[rows_match], colnames(df)[cols_match]]
      
      # Subset the dataframe to only include matching rows and columns
      df_subset_2s <- df[rownames(subset_2s), colnames(subset_2s)]
      
      # Fill in the matching values from the dataframe to the result matrix
      matrix_predict_2s[rownames(df_subset_2s), colnames(df_subset_2s)] <- as.matrix(df_subset_2s)
      
    }
  }
  
  result <- list(matrix_predict_1s = matrix_predict_1s, matrix_predict_2s = matrix_predict_2s)
  
  return(result)
  
}

# EoF
#----------------------------------------------------------------------------------------------

