-- Comparing default rates by the number of months with repayment delays
SELECT
    number_of_months_with_delay,
    COUNT(*) AS total_clients,
    SUM(CAST(Y AS int)) AS defaults,
    ROUND(100.0 * AVG(CAST(Y AS float)), 2) AS default_rate_pct
FROM dbo.credit_default_data
GROUP BY number_of_months_with_delay
ORDER BY number_of_months_with_delay;