-- Checking missing values in the imported ratio column
SELECT
    COUNT(*) AS total_rows,
    COUNT(latest_bill_to_credit_limit_ratio) AS non_null_ratios,
    COUNT(*) - COUNT(latest_bill_to_credit_limit_ratio) AS null_ratios
FROM dbo.credit_default_data;