# Feature Engineering Policy

## 1. Purpose

This document defines the derived features used in the Credit Risk Decision Support project. The objective is to represent historical repayment behaviour, bill amounts, and payment activity in a form suitable for exploratory analysis and credit-default modelling.

The cleaned source dataset remains unchanged. Derived features will be created in a separate modelling dataset.

## 2. Approved Features

| Feature | Formula | Interpretation |
|---|---|---|
| `average_bill_amount` | Mean of `BILL_AMT1` to `BILL_AMT6` | Average statement balance across six months |
| `average_payment_amount` | Mean of `PAY_AMT1` to `PAY_AMT6` | Average payment amount across six months |
| `payment_to_bill_ratio` | Sum of six payment amounts / Sum of six bill amounts | Payment activity relative to statement balances |
| `maximum_payment_delay` | Maximum positive value across `PAY_0`, `PAY_2`–`PAY_6` | Highest recorded positive repayment-delay code |
| `number_of_months_with_delay` | Count of repayment-status values greater than zero | Number of months with a recorded positive delay |
| `latest_bill_to_credit_limit_ratio` | `BILL_AMT1 / LIMIT_BAL` | Latest statement balance relative to credit limit |
| `latest_payment_to_bill_ratio` | `PAY_AMT1 / BILL_AMT1` | Latest payment relative to the latest statement balance |

## 3. Calculation Rules

- Bill amounts use `BILL_AMT1` through `BILL_AMT6`.
- Payment amounts use `PAY_AMT1` through `PAY_AMT6`.
- Repayment history uses `PAY_0`, `PAY_2`, `PAY_3`, `PAY_4`, `PAY_5`, and `PAY_6`.
- Only repayment-status values greater than zero count as positive delays. Codes `-2`, `-1`, and `0` are not counted as positive delays.
- The original repayment-status values are retained; they are not recoded by these calculations.

## 4. Zero-Denominator Handling

For ratio features, division by zero must not produce infinity or an invalid numerical value.

- If the denominator is zero, the ratio will be set to `NaN`.
- These cases will be counted and inspected before deciding how they should be handled during modelling.
- Negative bill amounts will not automatically be treated as errors or missing values.

For `payment_to_bill_ratio`, the denominator is the sum of the six bill amounts. For `latest_payment_to_bill_ratio`, the denominator is `BILL_AMT1`.

## 5. Target Leakage Prevention

The target variable is `Y`, representing default payment next month. All derived features use the historical credit, bill, payment, and repayment-status variables available in the dataset.

The target `Y` must not be used to calculate any feature. It will remain the outcome variable for model training and evaluation.

## 6. Feature Restrictions and Limitations

- `ID` is not a predictive feature.
- `SEX`, `EDUCATION`, and `MARRIAGE` are excluded from the primary model and reserved for a limited outcome audit.
- `AGE` will be considered only after discussing its ethical limitations and comparing models with and without it.
- Ratios and averages summarise historical behaviour but do not establish causal relationships.
- The dataset represents Taiwanese credit-card clients and historical data from 2005. Results should not be assumed to generalise to current borrowers or the Indian credit market.

## 7. Status

Approved feature definitions for Phase 2. Implementation, zero-denominator checks, and validation will be completed in the notebook before modelling.

## 8. Zero-Denominator Handling

For both ratio features, the denominator must be positive. If the denominator is zero or negative, the ratio is set to `NaN` because the resulting ratio may be undefined or misleading. The original bill and payment amounts remain unchanged. Missing ratio values will be assessed before modelling; no arbitrary imputation or outlier capping will be applied during feature engineering.

## 9. Final Feature Selection

Five engineered features are retained in the current dataset:

1. `average_bill_amount`
2. `average_payment_amount`
3. `maximum_payment_delay`
4. `number_of_months_with_delay`
5. `latest_bill_to_credit_limit_ratio`

The features `payment_to_bill_ratio` and `latest_payment_to_bill_ratio` were excluded from the final engineered dataset because very small positive bill amounts produced extreme ratios that could be misleading. The original bill and payment values were retained without modification.

All five retained engineered features have zero missing values. The final engineered dataset contains 29,965 rows and 29 columns, including the original predictors and target variable.
