-- Comparing default rates across credit-limit ranges
SELECT
    CASE
        WHEN LIMIT_BAL < 100000 THEN 'Below 100K'
        WHEN LIMIT_BAL < 200000 THEN '100K-199K'
        WHEN LIMIT_BAL < 400000 THEN '200K-399K'
        ELSE '400K and above'
    END AS credit_limit_band,
    COUNT(*) AS total_clients,
    SUM(CAST(Y AS int)) AS defaults,
    ROUND(100.0 * AVG(CAST(Y AS float)), 2) AS default_rate_pct
FROM dbo.credit_default_data
GROUP BY
    CASE
        WHEN LIMIT_BAL < 100000 THEN 'Below 100K'
        WHEN LIMIT_BAL < 200000 THEN '100K-199K'
        WHEN LIMIT_BAL < 400000 THEN '200K-399K'
        ELSE '400K and above'
    END
ORDER BY MIN(LIMIT_BAL);