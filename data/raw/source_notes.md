# Dataset Source Notes

## Source

**Dataset:** Default of Credit Card Clients  
**Repository:** UCI Machine Learning Repository  
**Dataset ID:** 350  
**DOI:** 10.24432/C55S3H  
**Source URL:** https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients

## Purpose

I am using this dataset to examine whether historical repayment behaviour, bill amounts, payment amounts and credit limits can help identify credit-card clients who are more likely to default in the following month.

The project will compare Logistic Regression with a Random Forest model. A Dummy Classifier will provide a baseline for evaluating whether the trained models offer a meaningful improvement.

## Dataset Details

- Number of observations: 30,000
- Number of predictor variables: 23
- Target variable: `Y`
- Target values: `0` = no default, `1` = default
- Population: Credit-card clients in Taiwan
- Historical repayment and billing period: April to September 2005

The dataset was retrieved using the `ucimlrepo` Python package with dataset ID 350.

## Limitations

The data represents Taiwanese credit-card clients and a historical period around 2005. The results should not be treated as representative of current borrowers or borrowers in India.

The model is being developed for educational and portfolio purposes. Its predictions and proposed risk categories are illustrative and are not intended for actual lending decisions.

The dataset contains demographic attributes. The project will restrict their use in the primary model and conduct a limited fairness audit as described in the project methodology.

## Citation

Yeh, I.-C., and Lien, C.-H. (2009). *The comparisons of data mining techniques for the predictive accuracy of probability of default of credit card clients*. Expert Systems with Applications.

Dataset DOI: https://doi.org/10.24432/C55S3H