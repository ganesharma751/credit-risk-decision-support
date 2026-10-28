-- Comparing default rates across latest repayment-status categories
SELECT
    PAY_0,
    COUNT(*) AS total_clients,
    SUM(CAST(Y AS int)) AS defaults,
    ROUND(100.0 * AVG(CAST(Y AS float)), 2) AS default_rate_pct
FROM dbo.credit_default_data
GROUP BY PAY_0
ORDER BY PAY_0;