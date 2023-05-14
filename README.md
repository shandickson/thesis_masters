# Research Masters Thesis: Nonresponse Bias Project

Here you will find all the necessary information to reproduce the analysis and results in the paper:

[An update on the link between nonresponse rate and nonresponse bias: A network analysis](./manuscript/thesis_final_sdickson.pdf). 

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)
- [Contact](#contact)

## Overview

In this project, we used a novel network analysis method to investigate the link between nonresponse rate and nonresponse bias in a diverse collection of surveys. Our goal was to update the results from the landmark study by Groves and Peytcheva (2008), and to implement a causal perspective on this issue. In this repository, I make all the data and analysis scripts available along with instructions on how to go about reproducing the results. If you have any questions please jump to my details at the bottom of this page. 

**The structure of the repository is as follows:**

| File / Folder                           | Contents      | 
| :-----------                            | :------------ | 
| [`LICENSE`](./LICENSE-CC-BY-NC-4.0.md)  | The contents of this repository are made available under the CC-NC-BY-4.0 License |
| [`analysis`](/analysis)                 | Here you will find four scripts: <br> <br> [`data_preparation.Rmd`](./analysis/data_preparation.Rmd) to preprocess the data <br> <br> [`data_descriptives.Rmd`](./analysis/data_descriptives.Rmd) to produce descriptive analyses <br> <br> [`data_networks.Rmd`](./analysis/data_networks.Rmd) to run the network analysis <br> <br> [`functions.R`](./analysis/functions.R) contains all custom-built functions for the above scripts <br> <br> And three subfolders: <br> <br> [`data`](./analysis/data) divided further into [`input`](./analysis/data/input) and [`output`](./analysis/data/output) <br><br> [`img`](./analysis/img) containing all images produced for the manuscript <br><br> [`tables`](./analysis/tables) containing all tables produced for the manuscript. |
| [`manuscript`](./manuscript)            | Here you will find everything you need to generate the manuscript: <br> <br> [`thesis_final_sdickson.pdf`](./manuscript/thesis_final_sdickson.pdf) the manuscript PDF <br> <br> [`thesis_final_sdickson.Rmd`](./manuscript/thesis_final_sdickson.Rmd) the .Rmd that generates the manuscript (open and click knit) <br> <br> [`bibliography.bib`](./manuscript/bibliography.bib) containing all citations/references <br> <br> [`asa.csl`](./manuscript/asa.csl) containing the reference style (American Statistical Association) |

Ethical approval for the research conducted was granted by the FETC under file number 22-2063. Data arise from a meta-analysis of studies that included a survey on nonresponse rate and nonresponse bias. As such, there is no data relating to individual persons and therefore no privacy concerns. However, see the licence for conditions of use. 

## Installation

All analysis was conducted in `R` and `R Studio (version 4.1.2)` on MacOS Ventura 13.3.1. As such, you will need to [install the relevant version](https://cran.r-project.org/mirrors.html) for your OS if you do not have it already.

Once `R` and `R Studio (version 4.1.2)` are installed, you will need to check for and install certain packages used in the analysis by running the code below:

```{r}
# Create a list of the necessary packages:
packages <- c(devtools, forcats, jtools, weights, gtsummary, kableExtra, tidyverse, ggplot2, jcolors, ggnewscale, ggpubr, ggsci, ggthemes, mgm, bootnet, qgraph)

# Install these packages, if they are not already:
lapply(packages, require, character.only = TRUE)
```

If this throws an error, you can try to install packages one by one. For example:

```{r}
install.packages("mgm")
```
Note that all packages required to run a script are loaded at the top of each .Rmd file. If you are missing a package that you then try to load, check there for the culprit and install it using the method described above. 

## Usage

Once you have the software installed and the relevant files downloaded to your own device, you should run [`data_preparation.Rmd`](./analysis/data_preparation.Rmd), [`data_descriptives.Rmd`](./analysis/data_descriptives.Rmd), and [`data_networks.Rmd`](./analysis/data_networks.Rmd) **_in this order_**. At minimum, you need the [`functions.R`](./analysis/functions.R) script and the [`nonresponse_database.rds`](./analysis/data/input/nonresponse_database.rds) to run [`data_preparation.Rmd`](./analysis/data_preparation.Rmd), but from then on the [`input`](./analysis/data/input) folder should be populated with the data files the remaining scripts call on. Keep the folder structure the same and you shouldn't have any issues. 

**Note:** A bootstrap procedure that is moderately computationally intensive is conducted in [`data_networks.Rmd`](./analysis/data_networks.Rmd), with the relevant code chunk specified to *not* run automatically (i.e., `eval=FALSE`). Instead, you can find the results of this procedure in the [`output`](./analysis/data/output) subfolder [here](./analysis/data/output/boots_nonparametric.RDS) and [here](./analysis/data/output/boots_casedropping.RDS). If you really want to run the procedure yourself, be prepared to wait between 12-18 hours depending on how many cores your device has.

**Structure of the entire repository (thus file dependencies) is as follows:**

```
├── analysis
│   ├── analysis.Rproj
│   ├── copy_output.R
│   ├── data_descriptives.Rmd
│   ├── data_networks.Rmd
│   ├── data_preparation.Rmd
│   ├── functions.R
│   ├── data
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

We want this project to be collaborative. There is a wealth of data and a thousand potential research questions. So, if you want to contribute to this project or start your own follow these steps:

Steps `a` use a GitHub user interface. Steps `b` use the terminal command line. Choose one.

1. Fork the repository:

    a. Navigate to the repository `thesis_masters > Fork > Create a new fork` to create a copy of the repository on your own Github. 

2. Clone the repository:

    a. On GitHub Desktop, navigate to `Clone` or `Clone Repository` and paste the repository URL: https://github.com/shandickson/thesis_masters. Choose where you want this to exist on your device and click `Clone Repository` to initiate the cloning.
    
    b. Using the terminal, paste and execute the following:

```bash
git clone https://github.com/shandickson/thesis_masters
```

3. Create a new branch:

    a. On Github Web, navigate to your cloned repository and click `Branch:main > new-branch-name > Create branch`.
    
    b. Using the terminal, paste and execute the following:

```bash
git checkout -b new-branch-name
```

4. Make and commit changes:

    a. On Github Desktop, add a summary and then navigate to `Commit > Commit to new-branch-name`. 
    
    b. Using the terminal, paste and execute the following: 

```bash
git commit
```

5. Push changes to forked repository: 

    a. On Github Desktop, navigate to to `Push Origin` to push any local changes to the remote repository.
    
    b. Using the terminal, paste and execute the following:

```bash
git push origin new-branch-name
```

Remember to change `new-branch-name` to something clear and meaningful. 

Note: The next step for contributors to this project would be to submit a pull request for any changes to be merged with my original repository. However, I will not be accepting pull requests at this time. This may change in future, but in the meantime, direct any burning requests/questions to me [here](#contact).

## License

The project is licensed under the [`CC-BY-NC-4.O`](./LICENSE-CC-BY-NC-4.0.md). You can read about the conditions of this licence [here](https://creativecommons.org/licenses/by-nc/4.0/).

## Acknowledgments

The project would not have been possible without [Dr Peter Lugtig](https://www.peterlugtig.com/), [Dr Bella Struminskaya](https://www.uu.nl/staff/BStruminskaya), and their team of survey-coders. I am grateful for their patience and supervision over the last few - rather challenging - months.

## Contact

This repository is maintained by [Shannon Dickson](https://shandickson.github.io/). If you have any questions please feel free to contact me via email:

Student: s.s.dickson@students.uu.nl \
Work: s.s.dickson@uu.nl \
Private: shannonsdickson@gmail.com
