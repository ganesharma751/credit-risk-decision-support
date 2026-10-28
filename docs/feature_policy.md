# Feature Engineering Policy

## 1. Purpose

In this project, I wanted to create a few features that summarise clients' repayment behaviour and financial activity across the six months of historical data. The original dataset already contained repayment status, bill amounts, payment amounts, and credit limits, but I wanted to see whether some of this information could be represented in a more compact form for analysis and modelling.

I kept the original variables and created the engineered features in a separate dataset. This allowed me to compare the derived features with the original data without changing the cleaned source file.

## 2. Features Considered

During feature engineering, I considered seven derived features.

| Feature | Formula | Purpose |
|---|---|---|
| `average_bill_amount` | Mean of `BILL_AMT1` to `BILL_AMT6` | Summarises the average bill amount across six months |
| `average_payment_amount` | Mean of `PAY_AMT1` to `PAY_AMT6` | Summarises the average payment amount across six months |
| `payment_to_bill_ratio` | Sum of six payment amounts divided by the sum of six bill amounts | Compares total payment activity with total bill amounts |
| `maximum_payment_delay` | Maximum of `PAY_0`, `PAY_2`, `PAY_3`, `PAY_4`, `PAY_5`, and `PAY_6` | Captures the highest repayment-status code recorded across the six months |
| `number_of_months_with_delay` | Count of repayment-status values greater than zero | Measures how often a positive repayment-delay code appeared |
| `latest_bill_to_credit_limit_ratio` | `BILL_AMT1 / LIMIT_BAL` | Compares the latest bill amount with the client's credit limit |
| `latest_payment_to_bill_ratio` | `PAY_AMT1 / BILL_AMT1` | Compares the latest payment amount with the latest bill amount |

I did not retain all seven features. After inspecting the ratio calculations, I excluded `payment_to_bill_ratio` and `latest_payment_to_bill_ratio` from the final engineered dataset.

## 3. Final Feature Selection

The final dataset contains five engineered features:

1. `average_bill_amount`
2. `average_payment_amount`
3. `maximum_payment_delay`
4. `number_of_months_with_delay`
5. `latest_bill_to_credit_limit_ratio`

The two excluded ratios could produce extreme values when their bill denominators were very small. This made them difficult to interpret reliably. Rather than cap these values arbitrarily or introduce another transformation just to retain the features, I decided to exclude them and keep the original bill and payment amounts unchanged.

This was a practical modelling decision for this dataset, not a claim that payment-to-bill ratios are never useful.

## 4. Calculation Rules

### Average bill and payment amounts

I calculated the average bill amount from `BILL_AMT1` through `BILL_AMT6` and the average payment amount from `PAY_AMT1` through `PAY_AMT6`.

These features summarise the six historical observations. They do not describe a client's current financial position.

### Repayment behaviour

The repayment history uses `PAY_0`, `PAY_2`, `PAY_3`, `PAY_4`, `PAY_5`, and `PAY_6`.

`maximum_payment_delay` records the maximum value across these variables. Since the original repayment-status codes include negative values and zero as well as positive values, I retained the original codes rather than recoding them during feature engineering.

`number_of_months_with_delay` counts the months in which the repayment-status value was greater than zero. Codes `-2`, `-1`, and `0` therefore do not contribute to this count.

These are summaries of the recorded repayment-status codes. They should not be interpreted as a complete measure of every aspect of a client's repayment behaviour.

### Latest bill-to-credit-limit ratio

I calculated `latest_bill_to_credit_limit_ratio` as:

`BILL_AMT1 / LIMIT_BAL`

The ratio is calculated only when `LIMIT_BAL` is positive. When the credit limit is zero or negative, the feature is set to `NaN`. Negative bill amounts are retained because they occur in the source data and should not automatically be treated as errors.

I did not cap the ratio values during feature engineering.

## 5. Target Leakage and Predictor Selection

The target variable is `Y`, which records whether the client defaulted on payment in the following month. I did not use `Y` to calculate any engineered feature.

For the primary modelling exercise, I excluded `SEX`, `EDUCATION`, `MARRIAGE`, and `AGE` from the predictor set. The model used the remaining 19 original predictors together with the five engineered features, giving 24 predictors in total.

This restriction was a modelling choice for the project. It does not establish that the model is free from bias, and excluding these demographic variables does not rule out indirect relationships between the remaining predictors and demographic characteristics.

## 6. Validation and Final Dataset

I saved the engineered dataset as `data/processed/credit_default_engineered.csv`. It contains **29,965 rows and 29 columns**, including the original variables, target, and five engineered features.

During the SQL Server import, I found that 196 values in `latest_bill_to_credit_limit_ratio` had been lost. I checked the original CSV, confirmed that the ratios were available there, and restored the missing SQL values using the original formula for rows with positive credit limits.

After the repair, the SQL completeness check reported zero missing values across the five engineered features. A separate ratio validation query returned zero mismatches between the stored ratio and the calculation from `BILL_AMT1` and `LIMIT_BAL`.

These checks confirm the completeness of the retained engineered features in the final SQL table and the consistency of the ratio calculation. They do not, by themselves, establish that the features improve model performance.

## 7. Limitations

The engineered features summarise historical data from Taiwanese credit-card clients around 2005. Their usefulness may differ for other populations or more recent lending environments.

Averages can hide changes between months, and repayment-status summaries compress several different codes into simple measures. The bill-to-credit-limit ratio can also be difficult to interpret when bill amounts are negative.

I used these features to support exploratory analysis and model comparison. Their inclusion should not be taken as evidence of a causal relationship with default or as proof that they are suitable for real lending decisions.