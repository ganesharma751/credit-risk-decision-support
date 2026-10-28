-- Comparing average bills and payments by default status
SELECT
    Y AS default_status,
    COUNT(*) AS total_clients,
    ROUND(AVG(average_bill_amount), 2) AS avg_bill_amount,
    ROUND(AVG(average_payment_amount), 2) AS avg_payment_amount,
    ROUND(AVG(latest_bill_to_credit_limit_ratio), 3) AS avg_latest_bill_limit_ratio
FROM dbo.credit_default_data
GROUP BY Y
ORDER BY Y;