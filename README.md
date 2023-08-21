# bloodmarker_BA_estimation
Code walkthrough of calculation of biological age acceleration using blood biomarkers and Full ENC model for a single sample observation, as per article "Biological Age Estimation Using Circulating Blood Biomarkers"

## Biological Age Estimation Using Circulating Blood Biomarkers
### Illustrative example

This folder contains the necessary files to illustrate the Biological Age Acceleration (BAA) calculation for a single observation:

_BAA = 10 × XBAβBA'_ 

Where XBA is the vector of (centered) biomarker and CA values for an individual and βBA' are the Beta coefficients for the blood markers based on the Full ENC model, as well as the age adjustment to restore the overall effect of age on the log hazard rate. See the Methods section of the paper for a full explanation of this BAA equation.

The folder contains 2 data files, alongside the R script:

1. sample_observation.csv 
A example observation with all biomarkers present which are required by the Full ENC model. 
This file assumes that all biomarkers have either been directly measured or imputed based on a reference dataset, such as UKBB. 
Age and Sex are also present, but are not required in the calculation of BAA, which depends only on the biomarker values. 
Note that some variables are logged, as indicated in the feature name.

2. coefficients_and_means.csv
This file contains the Full ENC model coefficients, the null (sex and age only model) coefficients as well as the mean for each of the biomarkers in the Scottish subset (our test set) of the UKBB. These means are used for centering the biomarker values prior to the BAA calculation.  

The folder contains the BAA calculation script in both .R and .ipynb format. 
