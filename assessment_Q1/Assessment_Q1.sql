-- Calculate savings details for each customer

WITH savings AS (
    SELECT 
        s.owner_id,  -- Unique identifier for each customer
        COUNT(s.id) AS savings_count,  -- Number of savings accounts
        SUM(s.amount) AS savings_total  -- Total amount in savings accounts
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),

-- Calculate investment details for each customer
investments AS (
    SELECT 
        p.owner_id,  -- Unique identifier for each customer
        COUNT(p.id) AS investment_count,  -- Number of investment plans
        SUM(p.amount) AS investment_total  -- Total amount in investment plans
    FROM plans_plan p
    GROUP BY p.owner_id
)
-- Select customers with both savings and investment plans
SELECT 
    u.id AS owner_id,  -- Unique identifier for each customer
    CONCAT(u.first_name, ' ', u.last_name) AS name,  -- Customer name
    s.savings_count,  -- Number of savings accounts
    i.investment_count,  -- Number of investment plans
    (s.savings_total + i.investment_total) AS total_deposits  -- Total deposits
FROM users_customuser u
-- Join savings and investment details with customer information
JOIN savings s ON u.id = s.owner_id
JOIN investments i ON u.id = i.owner_id
-- Filter customers with at least one savings account and one investment plan
WHERE s.savings_count >= 1 AND i.investment_count >= 1
-- Order results by total deposits in descending order
ORDER BY total_deposits DESC;