-- Checking the range and distribution of the imported ratio
SELECT
    MIN(latest_bill_to_credit_limit_ratio) AS min_ratio,
    MAX(latest_bill_to_credit_limit_ratio) AS max_ratio,
    AVG(latest_bill_to_credit_limit_ratio) AS avg_ratio
FROM dbo.credit_default_data;