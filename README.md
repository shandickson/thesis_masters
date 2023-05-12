# Research Master Thesis Repository

Repository for my thesis conducted for completion of the Research Masters Methodology & Statistics for the Biomedical, Behavioural, & Social Sciences at Utrecht University. 

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)
- [Contact](#contact)

## Overview

Inside this repository, you will find all materials necessary to reproduce my thesis for the Research Masters Methodology & Statistics for the Biomedical, Behavioural, & Social Sciences at Utrecht University (2021-2023 cohort). I used a network analysis to explore the relationships between nonresponse rate and nonresponse bias using a meta-analysis of over 113 studies. All of the information, data, and R code that you need to reproduce my results are contained in this repository.

## Installation

All analysis was conducted in R and R Studio (version 4.1.2). If you do not already have R, install the relevant version for your OS [here](https://cran.r-project.org/mirrors.html). Once R is up and running, you will need to run the following code to check for and install any necessary packages:

```{r}
# List of packages
packages <- c(tidyverse, forcats, jtools, weights, ggplot2, jcolors, ggmewscale, ggpubr, ggsci, kableExtra, gtsummary mgm, bootnet, qgraph, devtools, ggthemes)

# Install, if not already
lapply(packages, require, character.only = TRUE)
```

If this throws an error, you can try to install packages one by one. For example:

```{r}
install.packages("mgm")
```

## Usage

You can jump below to see the full structure of the repository, but I want to bring attention to the primary components:

* Inside `analysis`, there are three `.Rmd` files to run in order:
    - `data_preparation.Rmd`
    - `data_descriptives.Rmd`
    - `data_networks.Rmd` 
    - Additionally, a `functions.R` file that contains all custom functions used in the above scripts.
* Inside `data`, there are two further folders:
    - `input` where the raw and preprocessed data are
    - `output` where the results of the analysis scripts are
* Inside `img` and `tables` there are `.png`/`.pdf` images and `.RDS` files that are used when compiling the written manuscript. 


Note: If running the bootstrap procedure again this can take somewhere between 12-18 hours. The results of this procedure are saved in the `output` folder as `boots_casedropping.RDS` and `boots_nonparametric.RDS`. I recommend you skip re-running the bootstrap and just use the saved output files. 

The structure of the repository is as follows: 
```
├── analysis
│   ├── analysis.Rproj
│   ├── copy_output.R
│   ├── data
│   │   ├── data
│   │   │   ├── input
│   │   │   │   ├── data.RDS
│   │   │   │   ├── data_coded.RDS
│   │   │   │   ├── data_f2f.RDS
│   │   │   │   ├── data_mail.RDS
│   │   │   │   ├── data_paper.RDS
│   │   │   │   ├── data_tel.RDS
│   │   │   │   ├── data_web.RDS
│   │   │   │   ├── f2f_coded.RDS
│   │   │   │   ├── mail_coded.RDS
│   │   │   │   ├── nonresponse_database.rds
│   │   │   │   ├── paper_coded.RDS
│   │   │   │   ├── tel_coded.RDS
│   │   │   │   └── web_coded.RDS
│   │   │   └── output
│   │   │       ├── boots_casedropping.RDS
│   │   │       ├── boots_nonparametric.RDS
│   │   │       ├── df_ints_f2f.RDS
│   │   │       ├── df_ints_mail.RDS
│   │   │       ├── df_ints_overall.RDS
│   │   │       ├── df_ints_tel.RDS
│   │   │       ├── df_ints_web.RDS
│   │   │       ├── f2f_nodewise.RDS
│   │   │       ├── f2f_pairwise.RDS
│   │   │       ├── mail_nodewise.RDS
│   │   │       ├── mail_pairwise.RDS
│   │   │       ├── mgm_all_nodewise.RDS
│   │   │       ├── mgm_all_pairwise.RDS
│   │   │       ├── mgm_f2f_nodewise.RDS
│   │   │       ├── mgm_f2f_pairwise.RDS
│   │   │       ├── mgm_mail_nodewise.RDS
│   │   │       ├── mgm_mail_nodewisee.RDS
│   │   │       ├── mgm_mail_pairwise.RDS
│   │   │       ├── mgm_tel_nodewise.RDS
│   │   │       ├── mgm_tel_nodewisee.RDS
│   │   │       ├── mgm_tel_pairwise.RDS
│   │   │       ├── mgm_web_nodewise.RDS
│   │   │       ├── mgm_web_pairwise.RDS
│   │   │       ├── overall_int_df.RDS
│   │   │       ├── overall_nodewise.RDS
│   │   │       ├── overall_pairwise.RDS
│   │   │       ├── tel_nodewise.RDS
│   │   │       ├── tel_pairwise.RDS
│   │   │       ├── web_nodewise.RDS
│   │   │       └── web_pairwise.RDS
│   │   ├── input
│   │   │   ├── data.RDS
│   │   │   ├── data_coded.RDS
│   │   │   ├── data_f2f.RDS
│   │   │   ├── data_mail.RDS
│   │   │   ├── data_paper.RDS
│   │   │   ├── data_tel.RDS
│   │   │   ├── data_web.RDS
│   │   │   ├── f2f_coded.RDS
│   │   │   ├── mail_coded.RDS
│   │   │   ├── nonresponse_database.rds
│   │   │   ├── paper_coded.RDS
│   │   │   ├── tel_coded.RDS
│   │   │   └── web_coded.RDS
│   │   └── output
│   │       ├── boots_casedropping.RDS
│   │       ├── boots_nonparametric.RDS
│   │       ├── df_ints_f2f.RDS
│   │       ├── df_ints_mail.RDS
│   │       ├── df_ints_overall.RDS
│   │       ├── df_ints_tel.RDS
│   │       ├── df_ints_web.RDS
│   │       ├── f2f_nodewise.RDS
│   │       ├── f2f_pairwise.RDS
│   │       ├── mail_nodewise.RDS
│   │       ├── mail_pairwise.RDS
│   │       ├── mgm_all_nodewise.RDS
│   │       ├── mgm_all_pairwise.RDS
│   │       ├── mgm_f2f_nodewise.RDS
│   │       ├── mgm_f2f_pairwise.RDS
│   │       ├── mgm_mail_nodewise.RDS
│   │       ├── mgm_mail_nodewisee.RDS
│   │       ├── mgm_mail_pairwise.RDS
│   │       ├── mgm_tel_nodewise.RDS
│   │       ├── mgm_tel_nodewisee.RDS
│   │       ├── mgm_tel_pairwise.RDS
│   │       ├── mgm_web_nodewise.RDS
│   │       ├── mgm_web_pairwise.RDS
│   │       ├── overall_int_df.RDS
│   │       ├── overall_nodewise.RDS
│   │       ├── overall_pairwise.RDS
│   │       ├── tel_nodewise.RDS
│   │       ├── tel_pairwise.RDS
│   │       ├── web_nodewise.RDS
│   │       └── web_pairwise.RDS
│   ├── data_descriptives.Rmd
│   ├── data_networks.Rmd
│   ├── data_preparation.Rmd
│   ├── functions.R
│   ├── img
│   │   ├── boot_plots
│   │   │   ├── p_cd_stability.png
│   │   │   ├── p_cd_stability_all.png
│   │   │   ├── p_cd_stability_f2f.png
│   │   │   ├── p_cd_stability_mail.png
│   │   │   ├── p_cd_stability_tel.png
│   │   │   ├── p_cd_stability_web.png
│   │   │   ├── p_np_accuracy.png
│   │   │   ├── p_np_accuracy_all.png
│   │   │   ├── p_np_accuracy_all_WRONGLABS.png
│   │   │   ├── p_np_accuracy_f2f.png
│   │   │   ├── p_np_accuracy_mail.png
│   │   │   ├── p_np_accuracy_tel.png
│   │   │   ├── p_np_accuracy_web.png
│   │   │   ├── p_np_difference.png
│   │   │   └── p_np_difference_s.png
│   │   ├── centrality_plots
│   │   │   ├── all_strength.pdf
│   │   │   ├── all_strength.png
│   │   │   ├── all_strength_ei.pdf
│   │   │   ├── all_strength_ei.png
│   │   │   ├── strength_ei_overall.png
│   │   │   └── strength_overall.png
│   │   ├── dags
│   │   │   ├── PRISMA.docx
│   │   │   ├── PRISMA.pdf
│   │   │   ├── PRISMA.png
│   │   │   ├── dag_extended.png
│   │   │   ├── dag_groves.png
│   │   │   ├── h.docx
│   │   │   ├── network_legend.png
│   │   │   ├── thesis_images.pptx
│   │   │   └── title.pdf
│   │   ├── descriptive_plots
│   │   │   ├── p_between.pdf
│   │   │   ├── p_between.png
│   │   │   ├── p_bias_dist.pdf
│   │   │   ├── p_bias_dist.png
│   │   │   ├── p_dists.pdf
│   │   │   ├── p_dists.png
│   │   │   ├── p_everthing.pdf
│   │   │   ├── p_everthing.png
│   │   │   ├── p_nr_dist.pdf
│   │   │   ├── p_nr_dist.png
│   │   │   ├── p_nr_year.pdf
│   │   │   ├── p_nr_year.png
│   │   │   ├── p_nrb_year.pdf
│   │   │   ├── p_nrb_year.png
│   │   │   ├── p_within.pdf
│   │   │   ├── p_within.png
│   │   │   ├── p_within_between.pdf
│   │   │   ├── p_within_between.png
│   │   │   ├── p_year.pdf
│   │   │   └── p_year.png
│   │   ├── img
│   │   │   ├── boot_plots
│   │   │   │   ├── p_cd_stability.png
│   │   │   │   ├── p_np_accuracy.png
│   │   │   │   ├── p_np_difference.png
│   │   │   │   └── p_np_difference_s.png
│   │   │   ├── centrality_plots
│   │   │   │   └── all_strength.png
│   │   │   ├── dags
│   │   │   │   ├── dag_extended.png
│   │   │   │   ├── dag_groves.png
│   │   │   │   └── thesis_images.pptx
│   │   │   ├── descriptive_plots
│   │   │   │   ├── p_between.png
│   │   │   │   ├── p_bias_dist.png
│   │   │   │   ├── p_dists.png
│   │   │   │   ├── p_everthing.png
│   │   │   │   ├── p_nr_dist.png
│   │   │   │   ├── p_nr_year.png
│   │   │   │   ├── p_nrb_year.png
│   │   │   │   ├── p_within.png
│   │   │   │   ├── p_within_between.png
│   │   │   │   └── p_year.png
│   │   │   ├── moderated_networks
│   │   │   │   ├── mgm_mod.png
│   │   │   │   ├── mgm_mod_f2f.png
│   │   │   │   ├── mgm_mod_mail.png
│   │   │   │   ├── mgm_mod_paper.png
│   │   │   │   ├── mgm_mod_telephone.png
│   │   │   │   └── mgm_mod_web.png
│   │   │   └── split_networks
│   │   │       ├── mgm_all.pdf
│   │   │       ├── mgm_all.png
│   │   │       ├── mgm_f2f.pdf
│   │   │       ├── mgm_f2f.png
│   │   │       ├── mgm_mail.pdf
│   │   │       ├── mgm_mail.png
│   │   │       ├── mgm_telephone.pdf
│   │   │       ├── mgm_telephone.png
│   │   │       ├── mgm_web.pdf
│   │   │       └── mgm_web.png
│   │   ├── moderated_networks
│   │   │   ├── mgm_mod.png
│   │   │   ├── mgm_mod_f2f.png
│   │   │   ├── mgm_mod_mail.png
│   │   │   ├── mgm_mod_paper.png
│   │   │   ├── mgm_mod_telephone.png
│   │   │   └── mgm_mod_web.png
│   │   └── split_networks
│   │       ├── mgm_all.pdf
│   │       ├── mgm_all.png
│   │       ├── mgm_f2f.pdf
│   │       ├── mgm_f2f.png
│   │       ├── mgm_mail.pdf
│   │       ├── mgm_mail.png
│   │       ├── mgm_telephone.pdf
│   │       ├── mgm_telephone.png
│   │       ├── mgm_web.pdf
│   │       └── mgm_web.png
│   ├── plot_theme.R
│   └── tables
│       ├── t_country.RDS
│       ├── t_groves.RDS
│       ├── t_groves_modes.RDS
│       ├── t_modes.RDS
│       ├── t_nodewise.RDS
│       ├── t_source.RDS
└── manuscript
    ├── asa.csl
    ├── bibliography.bib
    ├── thesis_draft.Rproj
    ├── thesis_final_sdickson.Rmd
    └── thesis_final_sdickson.pdf
```

## Contributing

If you want to contribute to this project, you should do the following. 

1. Fork the Repository: Click the "Fork" button on the GitHub repository page. This will create a copy of the repository under your GitHub account.

2. Clone the Forked Repository: Clone the forked repository to your local machine using the git clone command. If you have GitHub Desktop installed, you can clone the repository that way too.

```bash
git clone https://github.com/shandickson/thesis_masters
```

3. Create a New Branch: Create a new branch on your local repository, where you can make changes to the code, using the git command:

```bash
git checkout -b new-changes
```

4. Make Changes and Commit: Make any desired changes to the project and commit to your local branch:

```bash
git commit
```

5. Push Changes to Forked Repository: Once contributors have committed their changes to their local branch, they should push the branch to their forked repository using the git push command. For example

```bash
git push origin new-changes
```

At this time, I will not be accepting pull requests for changes to the original repository. This may change in future, so check back here. You can always email me to chat about anything to do with this project. 

## License

This project is licensed under the CC-BY-NC-4.O which you can read about [here](https://creativecommons.org/licenses/by-nc/4.0/). A copy of the license if also found in this repository folder under the license name. 

## Acknowledgments

I'd like to acknowledge Dr Peter Lugtig and Dr Bella Struminskaya for their supervision on this project and for providing the raw data. 

## Contact

You can contact me using the email addresses below: 

Student: s.s.dickson@students.uu.nl \
Private: shannonsdickson@gmail.com
