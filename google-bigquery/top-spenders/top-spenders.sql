WITH metric_lookup AS (
  SELECT
    id AS metric_id,
    name AS metric_name
  FROM
    `proj-cdp-demo.demo_sfcc.klaviyo_metric`
  WHERE 
    name = 'Ordered Product' -- Retrieve the 'Ordered Product' metric dynamically
),

HighestSpender AS (
    SELECT 
        e.profile_id,
        SUM(CAST(JSON_EXTRACT_SCALAR(e.event_properties, "$['Price']") AS FLOAT64)) AS Total_Spent
    FROM 
        `proj-cdp-demo.demo_sfcc.klaviyo_event` e
    JOIN 
        metric_lookup ml ON e.metric_id = ml.metric_id
    GROUP BY 
        e.profile_id 
    ORDER BY 
        Total_Spent DESC 
)

SELECT 
    hs.profile_id,
    p.email,
    p.first_name,
    p.last_name,
    p.phone_number,
    hs.Total_Spent
FROM 
    HighestSpender hs
JOIN 
    `proj-cdp-demo.demo_sfcc.klaviyo_profile` p ON hs.profile_id = p.id
ORDER BY
    hs.Total_Spent DESC;
