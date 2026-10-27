# Data Dictionary — Default of Credit Card Clients

## Dataset Overview

This project uses the Default of Credit Card Clients dataset from the UCI Machine Learning Repository. It contains 30,000 observations of credit-card clients in Taiwan and is used to study whether past repayment behaviour and financial information can help predict default payment in the following month.

The dataset contains 23 predictor variables and one target variable. The UCI Python package returns the predictors as `X1` to `X23` and the target as `Y`.

## Variable Definitions

| Variable | Description |
|---|---|
| `X1` | Credit limit in New Taiwan dollars |
| `X2` | Sex: 1 = male, 2 = female |
| `X3` | Education level: 1 = graduate school, 2 = university, 3 = high school, 4 = others |
| `X4` | Marital status: 1 = married, 2 = single, 3 = others |
| `X5` | Age in years |
| `X6` | Repayment status in September 2005 |
| `X7` | Repayment status in August 2005 |
| `X8` | Repayment status in July 2005 |
| `X9` | Repayment status in June 2005 |
| `X10` | Repayment status in May 2005 |
| `X11` | Repayment status in April 2005 |
| `X12` | Bill statement amount in September 2005 |
| `X13` | Bill statement amount in August 2005 |
| `X14` | Bill statement amount in July 2005 |
| `X15` | Bill statement amount in June 2005 |
| `X16` | Bill statement amount in May 2005 |
| `X17` | Bill statement amount in April 2005 |
| `X18` | Previous payment amount in September 2005 |
| `X19` | Previous payment amount in August 2005 |
| `X20` | Previous payment amount in July 2005 |
| `X21` | Previous payment amount in June 2005 |
| `X22` | Previous payment amount in May 2005 |
| `X23` | Previous payment amount in April 2005 |
| `Y` | Default payment in the following month: 1 = default, 0 = no default |

### Repayment Status Encoding

The repayment-status variables use the following coding described by the dataset documentation:

- `-1` = paid duly
- `1` to `8` = payment delayed by the corresponding number of months
- `9` = payment delayed by nine months or more

The meaning of the value `0` is not explicitly defined in the variable information reproduced here. It will be inspected during data exploration rather than assigned an interpretation without verification.

## Target Distribution

The initial inspection returned the following counts:

| Target | Number of clients | Percentage |
|---|---:|---:|
| No default (`Y = 0`) | 23,364 | 77.88% |
| Default (`Y = 1`) | 6,636 | 22.12% |
| Total | 30,000 | 100% |

The target is imbalanced because the number of non-defaulting clients is considerably higher than the number of defaulting clients. Model evaluation will therefore include precision, recall, F1-score and ROC-AUC rather than relying on accuracy alone.

## Initial Data Quality Checks

- The imported feature matrix contains 30,000 rows and 23 columns.
- The target contains 30,000 rows and one column.
- No missing values were reported in the imported feature columns.
- There are 56 rows with repeated feature values.
- There are 35 exact duplicate records when both predictors and the target are considered.
- There are 21 feature combinations associated with more than one target value.

Repeated feature values do not necessarily represent duplicate clients. These observations will be investigated during data cleaning, and no records will be removed without a clear reason.

## Feature Policy

The primary model will exclude the ID, sex, education and marital-status variables. Sex, education and marital status will be reserved for a limited fairness audit. Age will be considered only after discussing its ethical limitations and comparing model results with and without it.

The final predictor set will be documented after the data-cleaning and feature-engineering stages.

## Source

UCI Machine Learning Repository: [Default of Credit Card Clients](https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients)

DOI: `10.24432/C55S3H`