# Dataset Source Notes

## 1. Source

- **Dataset:** Default of Credit Card Clients
- **Repository:** UCI Machine Learning Repository
- **Dataset ID:** 350
- **DOI:** [10.24432/C55S3H](https://doi.org/10.24432/C55S3H)
- **Source URL:** https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients

I used the UCI Machine Learning Repository's *Default of Credit Card Clients* dataset for this project. I retrieved the data using the `ucimlrepo` Python package with dataset ID 350.

## 2. Dataset Background

The dataset contains credit-card client information from Taiwan, including credit limits, repayment status, bill amounts, payment amounts, and demographic attributes. The records cover a historical period around 2005.

The dataset contains 30,000 original observations and 23 predictor variables, along with the target variable `Y`. The target records whether a client defaulted on their credit-card payment in the following month.

- `Y = 0`: No default
- `Y = 1`: Default

The repayment and billing variables cover six monthly periods, from April to September 2005. The dataset therefore provides a historical view of clients' repayment behaviour and financial activity before the target outcome.

## 3. How I Used the Data

I used the dataset to investigate whether repayment behaviour, bill amounts, payment amounts, and credit limits could help distinguish clients who defaulted from those who did not.

I first examined the structure of the data, the distribution of the target variable, and the available financial and repayment variables. During data preparation, I identified and removed 35 exact duplicate rows, leaving **29,965 records** for the subsequent analysis.

I then created a cleaned dataset and an engineered dataset. The engineered dataset contains five additional features derived from the original financial and repayment variables:

- `average_bill_amount`
- `average_payment_amount`
- `maximum_payment_delay`
- `number_of_months_with_delay`
- `latest_bill_to_credit_limit_ratio`

I also documented the feature-selection decisions, including why I excluded two payment-to-bill ratio features that could produce misleading values when bill amounts were very small.

The prepared data was used for exploratory analysis, model training and evaluation, and SQL-based analysis. I also imported the engineered dataset into SQL Server for further investigation and connected it to Power BI to build a two-page credit-risk dashboard.

## 4. Target Distribution

After removing the duplicate rows, the dataset contained:

| Target | Meaning | Records |
|---|---|---:|
| `Y = 0` | No default | 23,335 |
| `Y = 1` | Default | 6,630 |
| **Total** | | **29,965** |

The resulting default rate was **22.13%**. This class distribution was important when evaluating the models because a model could achieve apparently reasonable accuracy simply by predicting the majority class.

## 5. Limitations of the Source Data

The dataset represents Taiwanese credit-card clients during a historical period around 2005. It should not be treated as representative of current borrowers or the Indian credit market.

The data is useful for practising data cleaning, feature engineering, classification, SQL analysis, and dashboard development. However, its age and population limit the extent to which the findings can be generalised.

The project is educational and intended for my portfolio. The models and resulting comparisons are not validated for actual lending or credit-approval decisions.

The dataset includes demographic attributes. I excluded `SEX`, `EDUCATION`, `MARRIAGE`, and `AGE` from the primary model's predictor set. This was a modelling decision for this project; it does not establish that the remaining model is free from bias or that demographic factors have no relationship with default.

## 6. Citation

Yeh, I.-C., & Lien, C.-H. (2009). *The comparisons of data mining techniques for the predictive accuracy of probability of default of credit card clients*. Expert Systems with Applications.

Dataset DOI: https://doi.org/10.24432/C55S3H