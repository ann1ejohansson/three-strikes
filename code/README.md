{\rtf1\ansi\ansicpg1252\cocoartf2759
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww21100\viewh38100\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 ## A guide to the files in this directory.\
\
This project has three aims:  \
\
1. Replicate the multistate model from Ten Broeke et al. (2022).  \
2. Analyze individual differences in the effect of sequential errors on quitting.  \
3. Analyze the stability of these individual differences across domains.  \
\
Accordingly, scripts belonging to each of these aims can be found in the corresponding folder:  \
\
1. replication_multistate  \
2. ind_diff_addition  \
3. ind_diff_subtraction  \
\
The replication analysis is performed in three scripts:  \
1. replication_data_prep cleans the raw data and computes relevant variables  \
2. modelfit_msm.R fits the multistate model on the cleaned data. Fitted models are exported to the folder _models_.  \
3. replication.Rmd contains all analysis on the resulting model. It also the contains descriptive  \
   statistics reported in the final manuscript.   \
   * tables with relevant statistics reported in the final manuscript are saved to the folder _tables_.   \
   * plots are explorted to the folder _plots_.  \
   * for LaTeX formatting, the replication.Rmd script has also been knitted and all outputs are saved in LaTeX-friendly format in the folder _replication_files_.  \
   \
The folder _ind_diff_addition_ contains all scripts relevant for the analysis of individual differences in the Prowise Learn addition data.  \
\
1.  The data_prep folder contains the relevant data cleaning scripts for the addition data.  \
   *  load_addition_data.R loads in the raw addition data.  \
   *  addition_data_prep cleans the addition data and computes relevant variables.  \
2.  fit_mm.R fits the 2-state markov models to the addition data. All resulting models are saved to the _models_ folder. Here, there is a separation for models run on the training and testing data.  \
3.  fit_LMER.R fits the glmer models to the addition data. All resulting models are saved to the train or test subfolder of the _models_ folder.  \
4.  ind_diff_addition.Rmd is the main analysis script: it reads in the models fitted in their respective scripts, and performs all data analysis of these models reported in the final manuscript.  \
5.  Plots created in the file _ind_diff_addition.Rmd_ are saved to the folder _plots_. LaTeX formatted plots are saved in this folder, (subfolder _ind_diff_addition_files_).  \
6.  Tables presented in the final manuscript are saved in .csv format in the _tables_ folder.  \
\
\
The folder _ind_diff_subtraction_ contains all scripts relevant for the analysis of individual differences in the prowise learn subtraction data.   \
\
1.  The data_prep folder contains the relevant data cleaning scripts for the addition data.  \
   * load_subtraction_data.R loads in the raw subtraction data.  \
   * subtraction_data_prep cleans the subtraction data and computes relevant variables.  \
2.  fit_mm_subtraction.R fits the same markov models as for the addition data, with the subtraction data.  \
3.  fit_LMER_subtraction.R fits the same glmer models as for the addition data, with the subtraction data.  \
4.  ind_diff_subtraction.Rmd is the "mother" of all scripts in this folder. It analyzes all models relevant for the subtraction data. Additionally, it loads in the glmer models of the addition data and performs the stability models comparing the effect estimates in the addition and subtraction data. Plots and tables are exported to _plots_ and _tables_, respectively.\
\
**Extra notes:**  \
\
*  dependencies.R in a file that is sourced in most other files mentioned. It loads relevant libraries, plotting themes, and other specialized functions needed for the analyses in this paper. \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 *  At the beginning of each script, "training" or "testing" can be specified as the dataset to analyse. This will load in the correct dataset and save outputs in the correct subfolder. \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
}