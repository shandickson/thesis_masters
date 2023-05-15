
In this folder, you will find all the data that is used or generated in the project. 

1. input

    - Raw data file:                     `nonresponse_database.rds`
    - Clean data files:                  `data.RDS`, `data_f2f.RDS`, `data_tel.RDS`, `data_mail.RDS`, `data_web.RDS`, `data_paper.RDS`
    - Integer coded versions data files: `data_coded.RDS`, `f2f_coded.RDS`, `tel_coded.RDS`, `mail_coded.RDS`, `web_coded.RDS`, `paper_coded.RDS`
    
All of these data files are a result of the steps in `data_preparation.Rmd` and are further used in `data_descriptives.Rmd` and `data_networks.Rmd`. As you can see, there are full size data files and data files stratified by the survey mode plus integer coded versions of these files (required as input to `mgm`).

2. output

    - Nodewise parameters:        all files ending in `..._nodewise.RDS` contain saved nodewise parameters for each network model
    - Pairwise parameters:        all files ending in `..._pairwise.RDS` contain saved pairwise (averaged) parameters for each network model
    - All parameter interactions: all files beginning in `df_ints....RDS` contain saved individual interactions of the levels in each node for each network model
    
I do not list all the individual files as there are many. However, all of these data file result from `data_networks.Rmd` and are the relevant saved parameters from the `mgm` function. `mgm` saves nodewise (two sets of averaged regression estimates in each direction between two nodes), pairwise (average of these parameter sets), and all parameter interactions (estimates for each level of a node to each level of another node). 