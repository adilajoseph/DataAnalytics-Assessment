-- Calculate transaction details for each customer

WITH Trans_details AS (
    SELECT
        s.owner_id,  -- Unique identifier for each customer
        COUNT(*) AS total_transactions,  -- Total number of transactions
        MIN(s.created_on) AS first_trnx,  -- Date of the first transaction
        MAX(s.created_on) AS last_trnx,  -- Date of the last transaction
        -- Calculate the number of active months
        TIMESTAMPDIFF(MONTH, MIN(s.created_on), MAX(s.created_on)) + 1 AS active_months
    FROM savings_savingsaccount s
    WHERE s.owner_id IS NOT NULL  -- Ensure owner_id is not null
    GROUP BY s.owner_id
)
-- Categorize customers based on transaction frequency
, Frequency_Categorization AS (
    SELECT
        owner_id,
        total_transactions,
        active_months,
        -- Calculate average transactions per month
        ROUND(total_transactions / NULLIF(active_months, 0), 2) AS avg_tx_per_month,
        -- Categorize customers into frequency groups
        CASE
            WHEN ROUND(total_transactions / NULLIF(active_months, 0), 2) >= 10 THEN 'High Frequency'
            WHEN ROUND(total_transactions / NULLIF(active_months, 0), 2) >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM Trans_details
)
-- Group customers by frequency category and calculate average transactions per month

SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month
FROM Frequency_Categorization
GROUP BY frequency_category
-- Sort frequency categories in a specific order
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');