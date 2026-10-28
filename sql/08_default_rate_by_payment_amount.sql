-- Comparing average payment amounts for defaulters and non-defaulters
SELECT
    Y AS default_status,
    COUNT(*) AS total_clients,
    ROUND(AVG(average_payment_amount), 2) AS avg_payment_amount
FROM dbo.credit_default_data
GROUP BY Y
ORDER BY Y;