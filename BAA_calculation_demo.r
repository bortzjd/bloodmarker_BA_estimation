# Illustration of BAA calculation for a sample observation
# This file assumes that all biomarkers have either been directly measured or imputed based on a reference dataset, such as UKBB

#load tidy packages

library(tidyverse)

# read in sample_observation. 

sample <- read.csv('./Data/sample_observation.csv')

# read in the model coefficients. Both the null model and Elastic Net model coefficients are in the csv file
# in the same file, are the mean values of each biomarker from the Scottish subsample of UKBB (test set)
# these means will be used for the variable centering
# when applied outside of the UKBB context, the same should be done for the reference population in question

model_data <- read.csv('./Data/coefficients_and_means.csv')

# Sex is not used in the BAA calculation
# Only the difference between the age cofficient from the null model and the elastic net model is used in the BAA calcaultion
# i.e. Age_Coef_BAA = Age_Coef_ENET - Age_Coef_Null, where Null is the sex and Age only model
# this ensures that the average effect of chronological age on biological age at each age is retained within the CA term 
# (rather than reflected in the biomarker component due to covariance). The CA term is not used in the BAA estimation. 
# (see Methods section of paper)


sample_adj <- sample %>% filter(feature != 'sex')
model_data_adj <- model_data  %>% filter(feature != 'sexM')
# adjust age coefficient for the calculation of BAA
model_data_adj <- model_data_adj %>% mutate(BAA_coefficient = coefficient_ENET - coefficient_SexAge)


# values to be converted to numeric now that sex (character) has been removed

sample_adj$value <- as.numeric(sample_adj$value)


# Centering - variables are centered using the mean values of each feature from the Scottish test set
# The rationale here is that the "average" person in a reference population should display a BAA of 0 i.e BA = CA
# i.e. acceleration is measured in relation to the reference population itself

joined_data  <-  merge(sample_adj, model_data_adj, by = 'feature')
joined_data <- joined_data  %>% mutate(centeredValue = value - featureMean)

# now multiply the centered value by the coefficient, and sum the product. 
# multiplying by 10 gives the ultimate BAA (see Methods section of paper)
# for multiple data points, matrix multiplication is recommended
# Here, for a single observation, we simply multiply the columns and sum the resulting scalars

BAA <- sum(joined_data$centeredValue * joined_data$BAA_coefficient) * 10
BAA

# the biological age acceleration result is 1.5 years i.e Biological age is 1.5 years higher than chronological age
# For this sample individual, this implies a Biological Age of 69.5 vs Chronoligical age of 68
