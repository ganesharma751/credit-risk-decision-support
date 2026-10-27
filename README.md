# Credit Risk Decision Support — Consumer Card Default Modelling

## Project Overview

This project examines whether past repayment behaviour, bill amounts, payment amounts and credit limits can help identify credit-card clients at higher risk of defaulting in the following month.

The aim is to build a simple credit-risk decision-support workflow using Python, statistics, machine learning, SQL and Power BI. I will compare an interpretable Logistic Regression model with a Random Forest model and use a Dummy Classifier as the baseline.

The project will also examine how predicted default probabilities could be grouped into illustrative risk categories for a hypothetical approve, manual-review or restrict decision.

## Dataset

The project uses the [UCI Default of Credit Card Clients dataset](https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients).

- 30,000 observations
- 23 predictor variables
- Binary target: default payment next month
- Target values: `0` = no default, `1` = default

The initial target distribution contains 22.12% default cases and 77.88% non-default cases.

## Project Workflow

1. Understand the dataset and document its variables.
2. Clean the data and perform exploratory analysis.
3. Define the feature policy and create financial-behaviour features.
4. Establish a baseline and train the selected models.
5. Evaluate predictive performance and analyse predicted risk.
6. Conduct a limited fairness audit and perform SQL analysis.
7. Build a Power BI monitoring dashboard.
8. Document the findings, limitations and methodology.

## Tools

- Python
- pandas and NumPy
- Matplotlib
- scikit-learn
- SQL Server and SQL Server Management Studio
- Power BI
- Git and GitHub

## Model Scope

The primary model will be Logistic Regression, with Random Forest as a challenger model. A Dummy Classifier will establish the baseline.

Model evaluation will include precision, recall, F1-score, ROC-AUC, precision-recall analysis and probability calibration. Accuracy will not be treated as the main measure of performance.

## Feature Policy

The primary model will exclude ID, sex, education and marital status. Sex, education and marital status will be used only for a limited fairness and outcome audit. The inclusion of age will be considered separately because of its ethical implications.

## Current Status

**Phase 0 — Data understanding**

The dataset has been imported using `ucimlrepo` and its dimensions, target distribution, variable metadata and initial data-quality checks have been inspected.

Model training and final performance evaluation have not yet been completed. Findings and performance metrics will be added as the project progresses.

## Limitations and Responsible Use

The dataset represents Taiwanese credit-card clients and historical data from around 2005. Findings cannot automatically be generalised to current borrowers or borrowers in India.

The project is educational and intended for portfolio demonstration. The proposed risk thresholds are illustrative and must not be treated as a real credit policy.

A real lending system would require appropriate validation, economic analysis, regulatory compliance, fairness assessment and additional safeguards.

## Reproducibility

The dataset can be retrieved from the UCI Machine Learning Repository using the `ucimlrepo` Python package. The Python environment, data-processing steps, model settings and final results will be documented as the project develops.

## Dataset Citation

Yeh, I.-C., and Lien, C.-H. (2009). *The comparisons of data mining techniques for the predictive accuracy of probability of default of credit card clients*. Expert Systems with Applications.

DOI: https://doi.org/10.24432/C55S3H