# Data Dictionary — Default of Credit Card Clients

## 1. Dataset Overview

I used the Default of Credit Card Clients dataset from the UCI Machine Learning Repository to study the relationship between historical repayment behaviour, credit limits, bill amounts, payment amounts, and credit-card default.

The original dataset contains 30,000 observations from Taiwan. The UCI Python package initially returned the predictor variables as `X1` to `X23` and the target as `Y`. During data preparation, I worked with descriptive column names so the variables would be easier to understand and use in Python, SQL Server, and Power BI.

After removing 35 exact duplicate records, the working dataset contained **29,965 observations**. The cleaned dataset has 23 original predictors and the target variable, while the engineered dataset contains five additional features.

## 2. Original Variable Definitions

The following table maps the original dataset variables to their descriptive column names.

| Original variable | Project column name | Description |
|---|---|---|
| `X1` | `LIMIT_BAL` | Credit limit in New Taiwan dollars |
| `X2` | `SEX` | Sex: 1 = male, 2 = female |
| `X3` | `EDUCATION` | Education level: 1 = graduate school, 2 = university, 3 = high school, 4 = others |
| `X4` | `MARRIAGE` | Marital status: 1 = married, 2 = single, 3 = others |
| `X5` | `AGE` | Age in years |
| `X6` | `PAY_0` | Repayment status in September 2005 |
| `X7` | `PAY_2` | Repayment status in August 2005 |
| `X8` | `PAY_3` | Repayment status in July 2005 |
| `X9` | `PAY_4` | Repayment status in June 2005 |
| `X10` | `PAY_5` | Repayment status in May 2005 |
| `X11` | `PAY_6` | Repayment status in April 2005 |
| `X12` | `BILL_AMT1` | Bill statement amount in September 2005 |
| `X13` | `BILL_AMT2` | Bill statement amount in August 2005 |
| `X14` | `BILL_AMT3` | Bill statement amount in July 2005 |
| `X15` | `BILL_AMT4` | Bill statement amount in June 2005 |
| `X16` | `BILL_AMT5` | Bill statement amount in May 2005 |
| `X17` | `BILL_AMT6` | Bill statement amount in April 2005 |
| `X18` | `PAY_AMT1` | Payment amount in September 2005 |
| `X19` | `PAY_AMT2` | Payment amount in August 2005 |
| `X20` | `PAY_AMT3` | Payment amount in July 2005 |
| `X21` | `PAY_AMT4` | Payment amount in June 2005 |
| `X22` | `PAY_AMT5` | Payment amount in May 2005 |
| `X23` | `PAY_AMT6` | Payment amount in April 2005 |
| `Y` | `Y` | Default payment in the following month: 1 = default, 0 = no default |

The repayment, bill, and payment variables use different suffix conventions, so I kept the original descriptive column names after renaming the variables. This also made it easier to connect the prepared data to SQL Server and Power BI.

## 3. Repayment Status Encoding

The repayment-status variables record the repayment status for each historical month.

- `-1`: Paid duly, according to the dataset documentation.
- `1` to `8`: Repayment delay categories corresponding to the number of months delayed.
- `0`: A separate category in the data. I retained it as recorded rather than assigning it an interpretation that the supplied variable description did not establish.
- `9`: The original variable description includes this as a category for delays of nine months or more, although the observed repayment-status values in the working dataset should be checked before drawing conclusions about this category.

In the project, `PAY_0` represents the latest repayment-status variable, corresponding to September 2005. It was used in the SQL analysis to compare default rates across repayment-status categories.

## 4. Target Variable and Distribution

The target variable is `Y`.

| Value | Meaning | Records | Percentage |
|---|---|---:|---:|
| `0` | No default | 23,335 | 77.87% |
| `1` | Default | 6,630 | 22.13% |
| **Total** | | **29,965** | **100%** |

The target is imbalanced because non-defaulting clients substantially outnumber defaulting clients. For that reason, I evaluated the classification models using precision, recall, F1-score, and ROC-AUC alongside accuracy.

## 5. Engineered Features

I added five features to summarise repayment and financial behaviour across the historical observations.

| Feature | Description | Calculation |
|---|---|---|
| `average_bill_amount` | Average bill statement amount across the six historical months | Mean of `BILL_AMT1` to `BILL_AMT6` |
| `average_payment_amount` | Average payment amount across the six historical months | Mean of `PAY_AMT1` to `PAY_AMT6` |
| `maximum_payment_delay` | Maximum recorded repayment-delay value across the repayment-status variables | Maximum of `PAY_0`, `PAY_2`, `PAY_3`, `PAY_4`, `PAY_5`, and `PAY_6` |
| `number_of_months_with_delay` | Number of months with a positive repayment-status value | Count of repayment-status values greater than zero |
| `latest_bill_to_credit_limit_ratio` | Latest bill amount relative to the client's credit limit | `BILL_AMT1 / LIMIT_BAL`, when `LIMIT_BAL` is positive |

These features were intended to provide a more compact summary of repayment behaviour and financial activity. The ratio feature can be negative when the latest bill amount is negative; this is retained rather than automatically treated as an error.

I excluded two additional payment-to-bill ratio features from the final engineered dataset because very small bill amounts could produce extreme ratios that would be difficult to interpret reliably. The reasons for this decision are documented in `docs/feature_policy.md`.

## 6. Data Quality and Preparation

The original dataset contained 30,000 records. During cleaning, I identified 35 exact duplicate rows and removed them, leaving 29,965 records.

The final prepared files are:

- `data/processed/credit_default_clean.csv` — cleaned original variables and target.
- `data/processed/credit_default_engineered.csv` — cleaned data with the five engineered features.

I also imported the engineered dataset into the `CreditRiskDB` database in SQL Server. During the import, 196 values in `latest_bill_to_credit_limit_ratio` were lost. I identified this issue by comparing the imported values with the feature formula and restored those ratios using `BILL_AMT1 / LIMIT_BAL` for rows with positive credit limits. The final SQL completeness check returned zero missing values across the five engineered features, and the ratio validation query returned zero mismatches.

## 7. Modelling Considerations

For the primary modelling exercise, I excluded `SEX`, `EDUCATION`, `MARRIAGE`, and `AGE` from the predictor set. The final model used 24 predictors, including the five engineered features, after excluding these four demographic variables from the 28 available non-target columns.

I compared a Dummy Classifier baseline with Logistic Regression and Random Forest. The evaluation included a stratified train-test split, cross-validation, and a threshold comparison using out-of-fold predictions. The detailed model results and threshold-selection limitations are recorded separately in `docs/model_evaluation.md`.

Excluding demographic variables does not prove that a model is fair or free from indirect bias. This project does not establish production suitability for lending decisions.

## 8. Source

UCI Machine Learning Repository: [Default of Credit Card Clients](https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients)

Dataset DOI: [10.24432/C55S3H](https://doi.org/10.24432/C55S3H)

Yeh, I.-C., & Lien, C.-H. (2009). *The comparisons of data mining techniques for the predictive accuracy of probability of default of credit card clients*. Expert Systems with Applications.