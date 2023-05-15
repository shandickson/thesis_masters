
In this folder you will find all the necessary files to generate the manuscript:

1. thesis_final_sdickson.Rmd

      - Open this file and navigate to the `knit` button to generate the .pdf version

2. bibliography.bib

      - Ensure this is in the same folder as thesis_final_sdickson.Rmd as it contains the BibLaTeX references the .Rmd calls on

3. asa.csl

      - Ensure this is in the same folder as thesis_final_sdickson.Rmd as it styles the references/bibliography according to the American Statistical Association, according to the standards set by the Journal of Survey Statistics and Methodology
      

Note: the thesis_final_sdickson.Rmd also calls on the contents of [`data`](../analysis/data), [`img`](../analysis/img), [`tables`](../analysis/tables) within the [`analysis`](../analysis) folder. All file paths in thesis_final_sdickson.Rmd are correct for this. Tables in the manuscript are creating using `kableExtra` or the `LaTex` code, depending on the desired level of formatting. 