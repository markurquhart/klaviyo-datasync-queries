WITH email_product_engagement AS (
  SELECT 
    e.profile_id,
    JSON_EXTRACT_SCALAR(e.event_properties, '$.Product Name') AS product_name,
    JSON_EXTRACT_SCALAR(e.event_properties, '$.Price') AS product_price,
    m.name AS metric_name,
    e.datetime
  FROM 
    `proj-cdp-demo.demo_sfcc.klaviyo_event` e
  JOIN 
    `proj-cdp-demo.demo_sfcc.klaviyo_metric` m
  ON 
    e.metric_id = m.id
  WHERE 
    m.name IN ('Opened Email', 'Viewed Product', 'Placed Order', 'Ordered Product')
    AND JSON_EXTRACT_SCALAR(e.event_properties, '$.Product Name') IS NOT NULL
)
SELECT 
  p.first_name,
  p.last_name,
  p.email,
  ep.product_name,
  COUNT(ep.product_name) AS engagement_count,
  MAX(CAST(ep.product_price AS FLOAT64)) AS latest_price,
  MAX(ep.datetime) AS last_engagement
FROM 
  email_product_engagement ep
JOIN 
  `proj-cdp-demo.demo_sfcc.klaviyo_profile` p
ON 
  ep.profile_id = p.id
GROUP BY 
  p.first_name, p.last_name, p.email, ep.product_name
ORDER BY 
  engagement_count DESC, last_engagement DESC
LIMIT 10;
