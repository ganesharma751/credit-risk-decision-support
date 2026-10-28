-- Measuring the overall default rate in the dataset
SELECT
    COUNT(*) AS total_clients,
    SUM(CAST(Y AS int)) AS defaulted_clients,
    COUNT(*) - SUM(CAST(Y AS int)) AS non_defaulted_clients,
    ROUND(100.0 * AVG(CAST(Y AS float)), 2) AS default_rate_pct
FROM dbo.credit_default_data;