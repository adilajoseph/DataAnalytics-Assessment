-- Calculate inactivity days for savings plans

SELECT 
    s.id AS plan_id,  -- Unique identifier for each plan
    s.owner_id,  -- Owner of the plan
    'Savings' AS type,  -- Type of plan (Savings)
    MAX(s.created_on) AS last_transaction_date,  -- Date of the last transaction
    DATEDIFF(CURDATE(), MAX(s.created_on)) AS inactivity_days  -- Number of days since the last transaction
FROM savings_savingsaccount s

-- Left join with plans_plan table (though it seems unused in the query)

LEFT JOIN plans_plan p
ON s.ID = p.ID

-- Group results by plan ID and owner ID

GROUP BY s.id, s.owner_id

-- Filter results to include only plans with more than 365 days of inactivity

HAVING MAX(s.created_on) < CURDATE() - INTERVAL 365 DAY;