#----------------------------------------------------------------------------------------------
# 1.2. This function creates a summary table for many variables, with the following steps:
#      - Create an empty vector to store the results
#      - Loop over the variables provided by the user
#      - Calculate the mean, standard error, and sample size
#      - Add the summaries to the results list and row bind
#      - Add the rownames to the summarised table
#      - Format the table with parameters from kableExtra

# SoF
get_summaries <- function(data, vars, grp, path) {
  # Summarize data
  t <- data %>%
    group_by(grp) %>%
    summarise(across(all_of(vars), mean, na.rm = TRUE)) %>%
    rename(ID = grp)
  
  # Write summary table to file
  readr::write_csv(t, path)
  
  # Format summary table for display
  t %>%
    kbl(digits = c(0, 2, 2),
        align = "l",
        booktabs = TRUE,
        linesep = "",
        caption = "Descriptive Statistics") %>% 
    kable_classic(position = "left",
                  latex_options = c("repeat_header","scale_down", "HOLD_position"),
                  full_width = TRUE) %>% 
    pack_rows(unique(t$ID)) %>%
    row_spec(0, bold = TRUE)
}

# Example usage
get_summaries(data, c("AbsRelbias", "RR", "SSize"), grp="Mode", "t1_desc.csv")


library(dplyr)

summarize_data <- function(data, group_var, summary_stats) {
  
  # Group data by the grouping variable
  grouped_data <- data %>% 
    group_by({{group_var}})
  
  # Calculate summary statistics for each group
  summary_table <- grouped_data %>% 
    summarize(across(all_of(summary_stats), list(mean = mean, sd = sd, n = n)))
  
  # Flatten the summary table
  pack_rows <- function(df, ID) {
    bind_rows(df, .id = "Stat") %>% 
      pivot_wider(names_from = "Stat", values_from = c("mean", "sd", "n")) %>% 
      mutate(ID = ID) %>% 
      select(ID, everything())
  }
  
  summary_table %>% 
    pack_rows(ID = unique(summary_table[[group_var]]))
}
# EoF
#----------------------------------------------------------------------------------------------

