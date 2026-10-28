-- Checking that the target contains only valid binary outcomes
SELECT
    Y,
    COUNT(*) AS total_clients
FROM dbo.credit_default_data
GROUP BY Y
ORDER BY Y;