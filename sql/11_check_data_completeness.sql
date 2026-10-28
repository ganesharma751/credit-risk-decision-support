-- Checking missing values in key engineered features
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN average_bill_amount IS NULL THEN 1 ELSE 0 END)
        AS missing_avg_bill,
    SUM(CASE WHEN average_payment_amount IS NULL THEN 1 ELSE 0 END)
        AS missing_avg_payment,
    SUM(CASE WHEN maximum_payment_delay IS NULL THEN 1 ELSE 0 END)
        AS missing_max_delay,
    SUM(CASE WHEN number_of_months_with_delay IS NULL THEN 1 ELSE 0 END)
        AS missing_delay_months,
    SUM(CASE WHEN latest_bill_to_credit_limit_ratio IS NULL THEN 1 ELSE 0 END)
        AS missing_latest_ratio
FROM dbo.credit_default_data;