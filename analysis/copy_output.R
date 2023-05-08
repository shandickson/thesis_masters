# ------------------------------------------------------------------------
# brief script to copy all the output from the analysis folder
# to where my manuscript is created. because it's easier for later me. 
# ------------------------------------------------------------------------
library(fs)

# check i'm in the right place:
getwd()
# check the structure of the analysis folder:
fs::dir_tree()

# copy the data folder to where I crate my manuscript:
fs::dir_copy("data",   "../manuscript/data", overwrite = TRUE)
# copy the tables folder to where I crate my manuscript:
fs::dir_copy("img",    "../manuscript/img", overwrite = TRUE)
# copy the img folder to where I create my manuscript:
fs::dir_copy("tables", "../manuscript/tables", overwrite = TRUE)

# ------------------------------------------------------------------------
# End. 
# ------------------------------------------------------------------------