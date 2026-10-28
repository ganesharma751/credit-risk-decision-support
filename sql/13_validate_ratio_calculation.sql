-- Checking whether the stored ratio matches BILL_AMT1 / LIMIT_BAL
SELECT
    COUNT(*) AS total_rows,
    SUM(
        CASE
            WHEN ABS(
                latest_bill_to_credit_limit_ratio
                - CAST(BILL_AMT1 AS float) / NULLIF(CAST(LIMIT_BAL AS float), 0)
            ) > 0.000001
            THEN 1
            ELSE 0
        END
    ) AS mismatched_ratios
FROM dbo.credit_default_data
WHERE LIMIT_BAL > 0;