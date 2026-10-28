# Credit Risk Decision Support — Consumer Card Default Modelling

## Project Overview

I built this project to investigate whether historical repayment behaviour, bill amounts, payment amounts, and credit limits can help identify credit-card clients at higher risk of defaulting in the following month.

The project combines data understanding, data cleaning, feature engineering, SQL analysis, machine learning, and Power BI visualisation in one workflow. My objective was not just to train a classifier, but to understand the data, validate the calculations, compare different modelling approaches, and communicate the findings through a dashboard.

I used a Dummy Classifier as a baseline, compared Logistic Regression with Random Forest, and examined how changing the classification threshold affected the balance between identifying defaults and generating false positives.

**Project type:** End-to-end data analytics and machine learning  
**Domain:** Credit risk and financial analytics  
**Primary tools:** Python, SQL Server, Power BI, Git and GitHub

## Key Results

- Processed **29,965 records** after removing 35 exact duplicate rows from the original 30,000-record dataset.
- Created five engineered financial-behaviour features to represent payment patterns, bill amounts, and credit utilisation.
- Used SQL Server to analyse default rates, repayment status, delayed payments, credit limits, and average bill and payment amounts.
- Trained and compared a Dummy Classifier, Logistic Regression, and Random Forest.
- Evaluated classification performance using precision, recall, F1-score, ROC-AUC, and five-fold cross-validation.
- Selected Logistic Regression at a classification threshold of 0.30 as the **provisional model**, based on its precision and F1-score balance.
- Built a two-page Power BI dashboard containing six KPIs, six charts, and three slicers.

## 1. Business Questions

I structured the project around the following questions:

1. What proportion of clients defaulted in the following month?
2. How does default risk vary across repayment-status categories?
3. Is the number of months with delayed payments associated with a higher default rate?
4. How do default rates differ across credit-limit groups?
5. How do average bill and payment amounts compare between clients who defaulted and those who did not?
6. Can machine learning models identify potential defaults more effectively than a simple majority-class baseline?
7. How does changing the classification threshold affect the number of defaults identified and the number of false positives?
8. How can the results be presented in a dashboard for monitoring and further investigation?

These questions connect the descriptive analysis with the predictive modelling stage. The SQL analysis helped identify patterns in the dataset, while the models evaluated whether the available predictors could distinguish between default and non-default cases.

## 2. Dataset and Source

I used the [Default of Credit Card Clients dataset](https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients) from the UCI Machine Learning Repository.

| Attribute | Details |
|---|---|
| Original observations | 30,000 |
| Original predictor variables | 23 |
| Target variable | `Y` |
| Target `Y = 0` | No default |
| Target `Y = 1` | Default payment next month |
| Geographic context | Taiwan |
| Historical period | 2005 |
| Final records after duplicate removal | 29,965 |

The dataset contains demographic information, credit limits, repayment status, bill amounts, and payment amounts. The repayment and financial variables provide a basis for examining the relationship between historical payment behaviour and subsequent default.

I retrieved the dataset using the `ucimlrepo` Python package rather than scraping data from web pages.

### Final target distribution

| Target | Clients | Share |
|---|---:|---:|
| No default | 23,335 | 77.87% |
| Default | 6,630 | 22.13% |
| **Total** | **29,965** | **100%** |

The dataset is imbalanced because non-default cases make up approximately 78% of the observations. This matters when evaluating model performance: a classifier can achieve reasonable accuracy by predicting the majority class while failing to identify defaults.

## 3. Technical Workflow

I completed the project through the following stages.

### Stage 1 — Data understanding and cleaning

- Retrieved the dataset using `ucimlrepo`.
- Examined its dimensions, variable descriptions, data types, and target distribution.
- Replaced the original `X1`–`X23` predictor names with descriptive names such as `LIMIT_BAL`, `PAY_0`, `BILL_AMT1`, and `PAY_AMT1`.
- Removed 35 exact duplicate rows, leaving 29,965 records.
- Examined the distribution of repayment-status categories and the financial variables.

### Stage 2 — Feature engineering

I created five additional features from the existing financial and repayment variables. These features summarise information across the six recorded periods and provide alternative representations of client behaviour.

### Stage 3 — SQL Server analysis

I imported the engineered dataset into SQL Server, checked the imported records and target distribution, investigated data-quality issues, and used SQL queries to compare default rates across different groups.

### Stage 4 — Model training and evaluation

I used a stratified training/test split, established a Dummy Classifier baseline, trained Logistic Regression and Random Forest, compared cross-validation results, and examined different classification thresholds.

### Stage 5 — Power BI dashboard

I created a two-page dashboard to present the credit-risk analysis through KPIs, charts, and slicers. The dashboard provides a visual summary of the dataset and its repayment and credit-profile patterns.

## 4. Data Preparation and Feature Engineering

The original dataset included 23 predictors and the target variable. After duplicate removal, I saved a cleaned dataset with 29,965 rows and 24 columns.

I then created an engineered dataset with 29 columns: the original 24 columns, including the target, plus five additional features.

### Engineered features

| Feature | Calculation | Purpose |
|---|---|---|
| `average_bill_amount` | Mean of `BILL_AMT1` to `BILL_AMT6` | Summarises average bill amounts across the recorded periods |
| `average_payment_amount` | Mean of `PAY_AMT1` to `PAY_AMT6` | Summarises average payment amounts |
| `maximum_payment_delay` | Maximum of `PAY_0`, `PAY_2` to `PAY_6` | Captures the highest repayment-status code across the recorded periods |
| `number_of_months_with_delay` | Count of repayment-status values greater than zero | Measures how frequently positive delay codes occurred |
| `latest_bill_to_credit_limit_ratio` | `BILL_AMT1 / LIMIT_BAL`, where `LIMIT_BAL > 0` | Measures the latest recorded bill relative to the credit limit |

I retained the original bill and payment amounts so that the engineered features could be compared with their underlying variables.

### Feature policy

I excluded the identifier from the modelling predictors and did not use the target variable to construct the engineered features.

I also considered two payment-to-bill ratios but excluded them from the final engineered dataset:

- `payment_to_bill_ratio`
- `latest_payment_to_bill_ratio`

Very small positive bill amounts could produce extreme ratio values, making these features potentially misleading. I therefore retained the original amounts and used the five features listed above.

### Data-quality issue during SQL import

During import into SQL Server, 196 values of `latest_bill_to_credit_limit_ratio` became `NULL`, even though the corresponding ratios were available in the processed CSV.

I investigated the affected rows and found that their credit limits were positive. I recalculated the missing values from the original bill amounts and credit limits using SQL, then validated the stored ratios.

The final checks confirmed:

- 29,965 records in the SQL table.
- No missing values across the five engineered features.
- Zero mismatches between the stored ratio and the recalculated ratio within the validation tolerance.

This was an important part of the project because it required checking the consistency of the data across Python and SQL Server rather than assuming that a successful import meant every value had been preserved.

## 5. SQL Server Analysis

I used SQL Server Management Studio (SSMS) to work with the `CreditRiskDB` database and its main table, `dbo.credit_default_data`.

The saved scripts in `sql/` cover database creation, import checks, ratio validation, default-rate analysis, group comparisons, and data completeness.

### Main findings

#### Overall default rate

The final dataset contained 6,630 default cases out of 29,965 records, giving an overall default rate of **22.13%**.

This provided the baseline for comparing default rates across repayment and credit-profile groups.

#### Repayment status

The default rate varied considerably across `PAY_0` categories. For example:

| Latest repayment status | Default rate |
|---:|---:|
| 0 | 12.81% |
| 1 | 34.03% |
| 2 | 69.13% |
| 3 | 75.78% |

Clients in the positive repayment-status categories generally showed higher default rates than clients in status 0. Categories with very few observations were less stable and required cautious interpretation.

#### Number of months with delays

The default rate increased with the number of recorded months containing positive delay codes.

| Months with delays | Default rate |
|---:|---:|
| 0 | 11.71% |
| 1 | 29.88% |
| 2 | 38.76% |
| 3 | 50.87% |
| 4 | 57.31% |
| 5 | 57.38% |
| 6 | 70.30% |

The default rate was 11.71% among clients with no recorded delays and 70.30% among clients with delays in all six periods. This was one of the clearest descriptive patterns in the analysis.

#### Credit limits

The default rate was lower in the higher credit-limit groups.

| Credit-limit range | Default rate |
|---|---:|
| Below 100K | 29.81% |
| 100K–199K | 20.78% |
| 200K–399K | 15.85% |
| 400K and above | 11.91% |

This is an association within the dataset, not evidence that increasing a credit limit would reduce default risk.

#### Average payment and bill amounts

| Target group | Average payment amount | Average bill amount |
|---|---:|---:|
| No default | 5,835.36 | 45,461.12 |
| Default | 3,331.23 | 43,509.58 |

The average payment amount among clients who defaulted was approximately **42.9% lower** than among non-defaulting clients. The average bill amount was approximately **4.3% lower**.

The difference suggests that payment behaviour may provide a stronger descriptive signal than average bill amount alone. These are group averages and do not establish a causal relationship or determine the outcome for an individual client.

### SQL scripts

The `sql/` directory contains the following saved scripts:

| Script | Purpose |
|---|---|
| `01_create_CreditRiskDB.sql` | Create the database |
| `02_check_imported_data.sql` | Check imported data |
| `03_check_ratio_range.sql` | Inspect the engineered ratio |
| `04_overall_default_rate.sql` | Calculate the overall default rate |
| `05_default_rate_by_repayment_status.sql` | Compare default rates by repayment status |
| `06_default_rate_by_delay_months.sql` | Compare default rates by number of delayed months |
| `07_default_rate_by_credit_limit.sql` | Compare default rates by credit-limit group |
| `08_default_rate_by_payment_amount.sql` | Compare average payment amounts |
| `09_default_rate_by_bill_amount.sql` | Compare average bill amounts |
| `10_bill_payment_comparison.sql` | Compare bills, payments, and their ratio |
| `11_check_data_completeness.sql` | Check missing engineered values |
| `12_validate_target.sql` | Validate target counts |
| `13_validate_ratio_calculation.sql` | Validate stored ratio calculations |

The detailed findings and interpretation are documented in [`docs/sql_analysis.md`](docs/sql_analysis.md).

## 6. Machine Learning

### Modelling setup

I used the engineered dataset to train and evaluate three classifiers:

1. Dummy Classifier — baseline.
2. Logistic Regression — primary candidate.
3. Random Forest — challenger model.

The predictor set contained 24 features: 19 original predictors and five engineered features. I excluded `SEX`, `EDUCATION`, `MARRIAGE`, and `AGE` from the modelling features used in this phase.

I used an 80:20 stratified train/test split with `random_state=42`.

| Split | Records | Predictors |
|---|---:|---:|
| Training | 23,972 | 24 |
| Test | 5,993 | 24 |

The Logistic Regression pipeline used `StandardScaler` followed by `LogisticRegression(max_iter=1000, random_state=42)`. The Random Forest used 200 trees, `random_state=42`, and `n_jobs=-1`.

### Evaluation metrics

I evaluated the models using:

- **Accuracy:** Overall proportion of correct predictions.
- **Precision:** Proportion of predicted defaults that were actual defaults.
- **Recall:** Proportion of actual defaults correctly identified.
- **F1-score:** Harmonic mean of precision and recall.
- **ROC-AUC:** Ability to rank default cases above non-default cases across classification thresholds.
- **Cross-validation:** Consistency of performance across five training folds.

Because default cases are the minority class, I placed particular emphasis on precision, recall, F1-score, and ROC-AUC rather than treating accuracy as the primary measure.

### Test-set performance at threshold 0.50

| Metric | Dummy Classifier | Logistic Regression | Random Forest |
|---|---:|---:|---:|
| Accuracy | 0.7787 | 0.8124 | 0.8093 |
| Precision | 0.0000 | 0.6695 | 0.6206 |
| Recall | 0.0000 | 0.3009 | 0.3552 |
| F1-score | 0.0000 | 0.4152 | 0.4518 |
| ROC-AUC | 0.5000 | 0.7515 | 0.7581 |

The Dummy Classifier achieved 77.87% accuracy by predicting no default for every client, but its recall for defaults was zero.

Both trained models performed better than the baseline. Random Forest had higher recall, F1-score, and ROC-AUC at the 0.50 threshold, while Logistic Regression had higher precision.

### Five-fold cross-validation

| Metric | Logistic Regression | Random Forest |
|---|---:|---:|
| ROC-AUC | 0.7601 ± 0.0087 | 0.7662 ± 0.0091 |
| Precision | 0.6500 ± 0.0268 | 0.6332 ± 0.0152 |
| Recall | 0.2936 ± 0.0071 | 0.3686 ± 0.0126 |
| F1-score | 0.4044 ± 0.0108 | 0.4658 ± 0.0117 |

Random Forest achieved higher average ROC-AUC, recall, and F1-score across the folds. Logistic Regression had higher precision.

### Threshold analysis

I also compared classification thresholds from 0.20 to 0.50 using out-of-fold probabilities generated through five-fold stratified cross-validation on the training data.

A threshold of **0.30 produced the highest F1-score among the thresholds tested for both models**.

| Metric at threshold 0.30 | Logistic Regression | Random Forest |
|---|---:|---:|
| Precision | 0.509 | 0.495 |
| Recall | 0.559 | 0.580 |
| F1-score | 0.533 | 0.534 |

At this threshold, the test-set results were approximately:

| Metric | Logistic Regression | Random Forest |
|---|---:|---:|
| Accuracy | 0.782 | 0.770 |
| Precision | 0.51 | 0.48 |
| Recall | 0.54 | 0.55 |
| F1-score | 0.53 | 0.51 |
| ROC-AUC | 0.7515 | 0.7581 |

Lowering the threshold increased recall but reduced precision and accuracy. This reflects a practical credit-risk trade-off: identifying more potential defaults can also result in more clients being incorrectly flagged.

### Model selection

I selected **Logistic Regression at a threshold of 0.30 as the provisional model**, with Random Forest retained as a challenger.

At the selected threshold, Logistic Regression had slightly higher precision and F1-score. Random Forest identified slightly more defaults but generated more false positives. The difference was small, and the results do not establish that Logistic Regression is universally superior.

The threshold is an experimental choice based on the metrics evaluated, not a validated lending policy. A real application would need to account for the financial consequences of false negatives and false positives.

The detailed methodology and results are available in [`docs/model_evaluation.md`](docs/model_evaluation.md).

## 7. Power BI Dashboard

I built a two-page Power BI dashboard to present the dataset and its repayment and credit-profile patterns.

### Page 1 — Overview

The overview page provides a high-level view of the dataset and its key indicators, helping the viewer understand the scale of the data and the overall default pattern.

### Page 2 — Payment and Credit Profile

The second page focuses on repayment and credit-profile analysis, complementing the overall view with more detailed comparisons.

The dashboard contains **six KPIs, six charts, and three slicers**. I used the slicers to make the views interactive rather than presenting the analysis as a set of static charts.

Dashboard screenshots are available in `reports/figures/`:

- `credit_risk_dashboard_page_1_overview.png`
- `credit_risk_dashboard_page_2_payment_and_credit_profile.png`

The Power BI file is intended to be stored at `dashboard/credit_risk_dashboard.pbix`.

## 8. Skills Demonstrated

### Data analytics and statistics

- Data inspection, cleaning, and validation.
- Duplicate detection and target-distribution analysis.
- Exploratory analysis of repayment and financial variables.
- Feature engineering using historical repayment and bill/payment data.
- Group comparisons and interpretation of default rates.
- Understanding class imbalance and classification metrics.

### Python and machine learning

- Data retrieval using `ucimlrepo`.
- Data manipulation using pandas and NumPy.
- Visualisation using Matplotlib.
- Preprocessing and model pipelines using scikit-learn.
- Logistic Regression and Random Forest classification.
- Stratified train/test splitting and five-fold cross-validation.
- Threshold comparison using out-of-fold predicted probabilities.
- Evaluation using precision, recall, F1-score, and ROC-AUC.

### SQL and database work

- SQL Server database and table operations.
- Import validation and data-quality checks.
- Aggregation and grouped default-rate analysis.
- Analysis using counts, averages, and conditional calculations.
- Validation and repair of engineered ratio values.
- Saving queries as reusable SQL scripts.

### Business intelligence and project practices

- Building a two-page Power BI dashboard.
- Presenting KPIs and interactive chart views.
- Organising project files and documenting the workflow.
- Version control and project hosting using Git and GitHub.
- Documenting assumptions, limitations, and modelling decisions.

## 9. Repository Structure

The repository is organised to separate source data, processed datasets, notebooks, SQL scripts, dashboard files, and documentation.

```text
credit-risk-decision-support/
├── data/
│   ├── raw/
│   │   ├── source_notes.md
│   │   └── data_dictionary.md
│   └── processed/
│       ├── credit_default_clean.csv
│       └── credit_default_engineered.csv
├── docs/
│   ├── feature_policy.md
│   ├── sql_analysis.md
│   └── model_evaluation.md
├── notebooks/
│   ├── 01_data_understanding_and_eda.ipynb
│   ├── 02_feature_engineering.ipynb
│   └── 03_model_training_and_evaluation.ipynb
├── reports/
│   └── figures/
│       ├── credit_risk_dashboard_page_1_overview.png
│       └── credit_risk_dashboard_page_2_payment_and_credit_profile.png
├── sql/
│   ├── 01_create_CreditRiskDB.sql
│   ├── 02_check_imported_data.sql
│   ├── ...
│   └── 13_validate_ratio_calculation.sql
├── dashboard/
│   └── credit_risk_dashboard.pbix
└── README.md
```

The tree represents the intended documented layout. File availability depends on what has been committed to the repository; the SQL Server database itself is local and is not recreated merely by cloning the repository.

## 10. Reproducibility

The dataset can be retrieved from the UCI Machine Learning Repository using `ucimlrepo`. The notebooks document the main data-understanding, feature-engineering, and modelling stages, while the SQL scripts provide reusable validation and analysis queries.

To reproduce the workflow:

1. Retrieve the dataset from UCI.
2. Run the data-understanding and cleaning steps.
3. Generate the engineered dataset using the documented feature definitions.
4. Import the processed data into SQL Server and run the validation and analysis queries.
5. Run the modelling notebook to reproduce the baseline and classifier evaluation.
6. Open the Power BI file to explore the dashboard, where the file is available.

The SQL scripts assume a local SQL Server environment and the database/table names documented above. The Power BI report also depends on the relevant file and data-source configuration being available.

## 11. Limitations and Responsible Use

This project is an educational and portfolio exercise, not a production credit-scoring system.

**Historical and geographic limitations:** The dataset represents Taiwanese credit-card clients and historical information from 2005. Its patterns may not generalise to current borrowers or the Indian credit market.

**Predictive limitations:** The models were evaluated on a held-out test set, but I inspected test-set performance before completing threshold selection. This introduces potential selection bias, so the reported test metrics may be optimistic as an estimate of performance on completely unseen data.

**Feature and fairness limitations:** The modelling features used in this phase excluded sex, education, marital status, and age. This does not establish that the resulting model is fair. A more complete assessment would require appropriate subgroup evaluation and additional checks.

**Decision-policy limitations:** A classification threshold of 0.30 was selected based on the F1-score among the thresholds tested. It has not been validated against real lending costs, regulatory requirements, or an institution's risk appetite.

**Causal limitations:** The relationships observed in the SQL analysis are descriptive. They do not establish that changing a credit limit, bill amount, or payment amount would cause default risk to change.

A real credit-risk application would require stronger out-of-sample validation, economic evaluation, fairness assessment, regulatory review, monitoring, and appropriate human oversight.

## 12. Conclusion

This project allowed me to work through an end-to-end analytics workflow, from understanding and cleaning a real-world dataset to engineering features, validating data in SQL Server, training classification models, and presenting findings in Power BI.

The SQL analysis showed strong associations between repayment delays and default rates. Average payment amounts also differed considerably between default and non-default groups. In modelling, both Logistic Regression and Random Forest substantially outperformed the Dummy Classifier, although they presented different trade-offs between precision and recall.

I retained Logistic Regression at a threshold of 0.30 as the provisional model because it provided a slightly better precision and F1-score balance at that threshold. I also documented the threshold-selection limitation and the historical scope of the dataset rather than treating the results as ready for real lending decisions.

The main outcome is a documented, multi-tool credit-risk analytics project that connects data quality, descriptive findings, model evaluation, and dashboard reporting.

## Dataset Citation

Yeh, I.-C., & Lien, C.-H. (2009). *The comparisons of data mining techniques for the predictive accuracy of probability of default of credit card clients*. Expert Systems with Applications.

DOI: [10.24432/C55S3H](https://doi.org/10.24432/C55S3H)

Dataset: [UCI Machine Learning Repository — Default of Credit Card Clients](https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients)

## Repository

[GitHub — Credit Risk Decision Support: Consumer Card Default Modelling](https://github.com/ganesharma751/credit-risk-decision-support)