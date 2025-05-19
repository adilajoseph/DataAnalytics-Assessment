-- Calculate customer transaction details
WITH CTE AS (
    SELECT 
        s.owner_id AS customer_id,  -- Unique identifier for each customer
        COUNT(*) AS total_transactions,  -- Total number of transactions
        CONCAT(u.first_name, ' ', u.last_name) AS name,  -- Customer name
        SUM(s.amount) AS total_amount,  -- Total amount transacted
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,  -- Customer tenure in months
        AVG(s.amount) AS avg_transaction_value,  -- Average transaction value
        MIN(s.created_on) AS first_transaction_date  -- Date of the first transaction
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s
    ON u.ID = s.ID
    GROUP BY s.owner_id, CONCAT(u.first_name, ' ', u.last_name), TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())
)
-- Select relevant columns from the CTE
, New_cte as (
    SELECT 
        total_transactions,
        total_amount,
        avg_transaction_value,
        tenure_months,
        name,
        customer_id 
    FROM CTE
)
-- Calculate estimated Customer Lifetime Value (CLV)
SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    -- Estimated CLV formula
    ROUND(
        (total_transactions / NULLIF(tenure_months, 0)) * 12 * (0.001 * avg_transaction_value),
        2
    ) AS estimated_clv
FROM New_cte
-- Order results by total transactions
ORDER BY total_transactions;