# SQL Analysis

## 1. Purpose

After preparing the dataset in Python, I imported the engineered data into SQL Server and used SQL queries to check data quality and analyse patterns in credit card default. The analysis focused on the overall default rate, repayment behaviour, number of delayed payments, credit limits, and bill and payment amounts.

The database was `CreditRiskDB`, and the main table was `dbo.credit_default_data`. I saved the SQL scripts in the `sql/` directory so that the checks and analysis can be reviewed or run again.

## 2. Data Validation

Before analysing the data, I checked the imported row count, target distribution, missing values, and engineered ratio.

The final dataset contained **29,965 records**, including 23,335 clients who did not default and 6,630 who defaulted. The overall default rate was **22.13%**.

During the SQL import, I found that 196 values in `latest_bill_to_credit_limit_ratio` had become `NULL`, even though the corresponding values were available in the processed CSV file. I investigated these records and found that all 196 had positive credit limits, so the ratio could be recalculated using the original bill amount and credit limit.

I updated the affected values using SQL and then checked the results. The completeness check showed no missing values across the five engineered features. The ratio validation query also returned zero mismatches across all 29,965 records.

This step was important because analysing the data before correcting the missing ratios could have produced incomplete results for calculations involving that feature.

## 3. Overall Default Rate

The first analysis established the baseline default rate.

| Target | Number of clients | Share of dataset |
|---|---:|---:|
| No default (Y = 0) | 23,335 | 77.87% |
| Default (Y = 1) | 6,630 | 22.13% |
| **Total** | **29,965** | **100%** |

Around one in five clients in this dataset defaulted the following month. This also showed why accuracy alone would not be sufficient for evaluating a default prediction model: a model that always predicted no default would already achieve approximately 77.87% accuracy while failing to identify any defaults.

## 4. Default Rate by Repayment Status

I compared the default rate across the categories of `PAY_0`, which represents the most recent repayment status recorded in the dataset.

| PAY_0 status | Clients | Defaults | Default rate |
|---:|---:|---:|---:|
| -2 | 2,750 | 364 | 13.24% |
| -1 | 5,682 | 954 | 16.79% |
| 0 | 14,737 | 1,888 | 12.81% |
| 1 | 3,667 | 1,248 | 34.03% |
| 2 | 2,666 | 1,843 | 69.13% |
| 3 | 322 | 244 | 75.78% |
| 4 | 76 | 52 | 68.42% |
| 5 | 26 | 13 | 50.00% |
| 6 | 11 | 6 | 54.55% |
| 7 | 9 | 7 | 77.78% |
| 8 | 19 | 11 | 57.89% |

The default rate was substantially higher for clients with positive repayment-status codes, particularly categories 2 and 3. For example, the default rate was 69.13% for status 2, compared with 12.81% for status 0.

This suggests that recent repayment difficulties are strongly associated with default in this dataset. However, the categories with very few clients, especially statuses 5 to 8, should be interpreted cautiously because their default rates are based on small samples.

## 5. Default Rate by Number of Months with Delays

I also examined `number_of_months_with_delay`, an engineered feature counting the repayment-status values greater than zero across the six recorded periods.

| Months with delays | Clients | Defaults | Default rate |
|---:|---:|---:|---:|
| 0 | 19,918 | 2,333 | 11.71% |
| 1 | 4,405 | 1,316 | 29.88% |
| 2 | 1,899 | 736 | 38.76% |
| 3 | 1,154 | 587 | 50.87% |
| 4 | 951 | 545 | 57.31% |
| 5 | 298 | 171 | 57.38% |
| 6 | 1,340 | 942 | 70.30% |

The results showed a clear overall pattern: clients with delays in more months generally had higher default rates. The rate increased from 11.71% among clients with no recorded delays to 70.30% among those with delays in all six periods.

This was one of the clearest patterns in the SQL analysis. It also supported retaining the engineered delay-related features for model development. The relationship is descriptive, however, and does not establish that delayed payments alone caused the subsequent default.

## 6. Default Rate by Credit Limit

I grouped clients by `LIMIT_BAL` to compare default rates across credit-limit ranges.

| Credit-limit range | Clients | Defaults | Default rate |
|---|---:|---:|---:|
| Below 100K | 11,443 | 3,411 | 29.81% |
| 100K–199K | 7,390 | 1,536 | 20.78% |
| 200K–399K | 9,058 | 1,436 | 15.85% |
| 400K and above | 2,074 | 247 | 11.91% |

The default rate decreased across the higher credit-limit groups in this dataset, from 29.81% for clients with limits below 100K to 11.91% for clients with limits of 400K and above.

This is an association within the observed data, not evidence that increasing a client's credit limit would reduce their risk. Other client characteristics and repayment behaviour may also be related to both credit limits and default.

## 7. Bill and Payment Amounts

I compared average bill and payment amounts between the two target groups.

| Target | Clients | Average payment amount | Average bill amount |
|---|---:|---:|---:|
| No default (Y = 0) | 23,335 | 5,835.36 | 45,461.12 |
| Default (Y = 1) | 6,630 | 3,331.23 | 43,509.58 |

The average payment amount among clients who defaulted was approximately 42.9% lower than among clients who did not default. In contrast, the average bill amount was only about 4.3% lower.

This difference suggests that payment behaviour may provide a more useful signal of default risk than the average bill amount alone. The comparison is based on group averages, so it does not mean that every client who defaulted paid less or that payment amount by itself can reliably identify future defaults.

I also explored bill-to-payment comparisons in SQL. I did not use the earlier group averages of the engineered ratio as final findings because that query was run before the missing ratio values were repaired. Those ratio comparisons should be rerun against the corrected table before being reported as final results.

## 8. SQL Scripts

The queries used for data validation and analysis are saved in the `sql/` directory.

| Script | Purpose |
|---|---|
| `01_create_CreditRiskDB.sql` | Create the database |
| `02_check_imported_data.sql` | Check the imported data |
| `03_check_ratio_range.sql` | Inspect the range of the engineered ratio |
| `04_overall_default_rate.sql` | Calculate the overall default rate |
| `05_default_rate_by_repayment_status.sql` | Compare default rates by repayment status |
| `06_default_rate_by_delay_months.sql` | Compare default rates by number of delayed months |
| `07_default_rate_by_credit_limit.sql` | Compare default rates by credit-limit group |
| `08_default_rate_by_payment_amount.sql` | Compare payment amounts across target groups |
| `09_default_rate_by_bill_amount.sql` | Compare bill amounts across target groups |
| `10_bill_payment_comparison.sql` | Compare bills, payments, and their ratio |
| `11_check_data_completeness.sql` | Check missing values in engineered features |
| `12_validate_target.sql` | Validate target counts |
| `13_validate_ratio_calculation.sql` | Check stored ratios against the expected calculation |

I also ran additional diagnostic queries while investigating the missing ratio values. These checks helped identify the affected records and verify the repair, although not every diagnostic query was saved as a separate script.

## 9. Limitations

The findings describe relationships in this particular dataset and should not be interpreted as causal effects. The dataset contains credit card clients from Taiwan and reflects historical information from 2005, so the results may not represent current borrowers or other markets.

Some repayment-status categories contain very few records, which makes their default rates less stable. Group averages also hide differences between individual clients, and SQL analysis alone does not establish how well a model will predict unseen defaults.

## 10. Conclusion

The SQL analysis helped me validate the processed data and identify patterns associated with credit card default. Repayment status and the number of months with delays showed the clearest differences in default rates. Average payment amounts also differed considerably between clients who defaulted and those who did not, while average bill amounts showed a smaller difference.

The checks also caught and resolved the loss of 196 engineered ratio values during SQL import. After correcting the issue, I verified the completeness of the engineered features and the ratio calculations before proceeding with the modelling work.

These findings provided a basis for the next stage of the project: training and evaluating classification models to predict the likelihood of default.