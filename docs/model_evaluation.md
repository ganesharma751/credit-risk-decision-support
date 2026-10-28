# Model Evaluation

## 1. Objective

The objective of this phase was to build and evaluate classification models for predicting whether a credit card client would default on their payment in the following month.

I started with a Dummy Classifier to establish a baseline, then compared Logistic Regression and Random Forest. I evaluated the models using precision, recall, F1-score, ROC-AUC, and cross-validation rather than relying on accuracy alone.

## 2. Data and Modelling Setup

I used the engineered dataset containing 29,965 records. The target variable was `Y`, where 0 represents no default and 1 represents default.

The predictor set contained 24 features: 19 original predictors and five engineered features. I excluded `SEX`, `EDUCATION`, `MARRIAGE`, and `AGE` from the modelling features used in this phase.

I split the data into training and test sets using an 80:20 stratified split with `random_state=42`.

| Dataset | Records | Predictors |
|---|---:|---:|
| Training set | 23,972 | 24 |
| Test set | 5,993 | 24 |

Stratification maintained approximately the same default rate in both sets, at around 22.13%.

## 3. Baseline Model

I used a Dummy Classifier that always predicted the majority class, meaning it predicted no default for every client.

| Metric | Result |
|---|---:|
| Accuracy | 0.7787 |
| Precision (default class) | 0.0000 |
| Recall (default class) | 0.0000 |
| F1-score (default class) | 0.0000 |
| ROC-AUC | 0.5000 |

The baseline achieved approximately 77.87% accuracy simply because most clients in the dataset did not default. However, it failed to identify any actual defaults.

This established why accuracy alone was not a sufficient measure for this problem. The models needed to identify default cases while keeping false positives at a manageable level.

## 4. Models Evaluated

### 4.1 Logistic Regression

I trained Logistic Regression using a pipeline with `StandardScaler` and `LogisticRegression(max_iter=1000, random_state=42)`. Scaling was included because Logistic Regression can be sensitive to differences in feature scales.

At the default classification threshold of 0.50, the test-set results were:

| Metric | Result |
|---|---:|
| Accuracy | 0.8124 |
| Precision | 0.6695 |
| Recall | 0.3009 |
| F1-score | 0.4152 |
| ROC-AUC | 0.7515 |

The model achieved a higher accuracy than the baseline and identified some default cases. However, its recall of approximately 30.09% meant that it missed many clients who actually defaulted.

### 4.2 Random Forest

I trained a Random Forest classifier using 200 trees, with `random_state=42` and `n_jobs=-1`.

At the default threshold of 0.50, the test-set results were:

| Metric | Result |
|---|---:|
| Accuracy | 0.8093 |
| Precision | 0.6206 |
| Recall | 0.3552 |
| F1-score | 0.4518 |
| ROC-AUC | 0.7581 |

Random Forest achieved a higher recall and F1-score than Logistic Regression at the 0.50 threshold. Its ROC-AUC was also slightly higher, although its accuracy and precision were lower.

The comparison suggested that Random Forest identified more default cases at the default threshold, but generated more false positives.

## 5. Cross-Validation

I used five-fold cross-validation on the training data to compare model performance across different splits. The reported values below are the mean scores, with the standard deviation after the ± symbol.

| Metric | Logistic Regression | Random Forest |
|---|---:|---:|
| ROC-AUC | 0.7601 ± 0.0087 | 0.7662 ± 0.0091 |
| Precision | 0.6500 ± 0.0268 | 0.6332 ± 0.0152 |
| Recall | 0.2936 ± 0.0071 | 0.3686 ± 0.0126 |
| F1-score | 0.4044 ± 0.0108 | 0.4658 ± 0.0117 |

Random Forest performed better on average in ROC-AUC, recall, and F1-score, while Logistic Regression had higher precision. The relatively small standard deviations indicated that the scores did not vary greatly across the five folds.

Cross-validation supported the initial comparison, but it did not remove the need to consider the practical trade-off between detecting defaults and incorrectly flagging clients who would not default.

## 6. Classification Threshold Analysis

Both models initially used a threshold of 0.50 to convert predicted probabilities into class labels. I also examined lower thresholds because missing a client who defaults can be costly in a credit-risk setting.

I generated out-of-fold predicted probabilities on the training data using five-fold stratified cross-validation. I then compared thresholds of 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, and 0.50, using F1-score as the main selection metric.

Among the thresholds tested, 0.30 gave the highest F1-score for both models.

| Model | Precision at 0.30 | Recall at 0.30 | F1-score at 0.30 |
|---|---:|---:|---:|
| Logistic Regression | 0.509 | 0.559 | 0.533 |
| Random Forest | 0.495 | 0.580 | 0.534 |

Lowering the threshold increased recall because the models classified more clients as potential defaulters. This came at the cost of lower precision, meaning more clients who would not default were also flagged.

The threshold of 0.30 was therefore a trade-off rather than a universally optimal choice. A real lending decision would need to account for the cost of missed defaults, the cost of false positives, and the institution's risk policy.

## 7. Test-Set Results at Threshold 0.30

After selecting 0.30 from the thresholds tested, I evaluated both models on the test set.

| Metric | Logistic Regression | Random Forest |
|---|---:|---:|
| Accuracy | Approximately 0.782 | Approximately 0.770 |
| Precision | Approximately 0.51 | Approximately 0.48 |
| Recall | Approximately 0.54 | Approximately 0.55 |
| F1-score | Approximately 0.53 | Approximately 0.51 |
| ROC-AUC | 0.7515 | 0.7581 |

The threshold change improved the detection of defaults compared with the 0.50 results, but reduced accuracy and precision. Logistic Regression had a slightly higher F1-score and precision at this threshold, while Random Forest retained a slightly higher ROC-AUC.

The ROC-AUC values did not change with the classification threshold because ROC-AUC evaluates the ranking of predicted probabilities across thresholds, rather than performance at a single classification cutoff.

### Confusion matrix comparison

The confusion matrices at threshold 0.30 were:

**Logistic Regression**

| | Predicted no default | Predicted default |
|---|---:|---:|
| Actual no default | 3,965 | 702 |
| Actual default | 604 | 722 |

**Random Forest**

| | Predicted no default | Predicted default |
|---|---:|---:|
| Actual no default | 3,864 | 803 |
| Actual default | 595 | 731 |

Random Forest correctly identified nine more defaults and missed nine fewer defaults than Logistic Regression. However, it also produced 101 more false positives.

This comparison made the trade-off clearer: Random Forest identified slightly more defaults, while Logistic Regression produced fewer false positives and had a slightly better F1-score at the selected threshold.

## 8. Model Selection

I selected **Logistic Regression at a threshold of 0.30 as the provisional model** for this project.

The decision was based on the results at the selected threshold rather than ROC-AUC alone. Logistic Regression achieved a slightly higher F1-score and precision, while Random Forest identified a few more defaults. The difference in F1-score was small, so the results do not establish that Logistic Regression is universally better.

Logistic Regression also provides a relatively straightforward baseline for interpreting how predictors relate to the model's predictions. Random Forest remains a useful challenger because its cross-validation scores and ROC-AUC were slightly higher.

The final choice would depend on the costs of false negatives and false positives in the intended application. I have not treated this model as a production-ready credit decision system.

## 9. Limitations

There are several limitations to this evaluation:

- **Threshold-selection bias:** I inspected test-set performance before completing the threshold comparison. The threshold was selected using out-of-fold training probabilities, but the earlier test-set inspection means the test set was not kept entirely untouched throughout the process. The final test metrics may therefore be somewhat optimistic as an estimate of performance on completely unseen data.
- **Historical dataset:** The data represents Taiwanese credit card clients from 2005. Its patterns may not transfer directly to current borrowers or other markets.
- **Class imbalance:** Default cases represented approximately 22.13% of the dataset. Accuracy alone would hide important differences in how well the models identify defaults.
- **Trade-off between errors:** Increasing recall also increased false positives. The preferred balance depends on the costs and consequences of each type of error.
- **Limited model comparison:** The evaluation covered a Dummy Classifier, Logistic Regression, and Random Forest. It does not establish that these are the best possible models for the problem.
- **No deployment validation:** These results are an initial modelling evaluation, not evidence that the model is suitable for automated lending decisions.

A stronger follow-up evaluation would keep the test set untouched until the modelling and threshold-selection decisions were finalised, then evaluate the selected approach once on that held-out set.

## 10. Conclusion

The modelling phase showed that both Logistic Regression and Random Forest performed better than the Dummy Classifier, which failed to identify any defaults. Random Forest had the higher cross-validation ROC-AUC and recall at the default threshold, while Logistic Regression offered a slightly better precision and F1-score balance at the selected threshold of 0.30.

I retained Logistic Regression at 0.30 as the provisional model, with Random Forest as a challenger. The results also showed that model evaluation depends on more than accuracy: the threshold changes the balance between missed defaults and false alarms.

The model should be treated as an exploratory decision-support approach. Further validation on appropriately separated data, and consideration of real credit-risk costs and policies, would be required before using it in practice.