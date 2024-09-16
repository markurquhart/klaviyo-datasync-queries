SELECT 
  JSON_EXTRACT_SCALAR(e.event_properties, "$['Subject']") AS email_subject,
  COUNT(e.id) AS open_count,
  EXTRACT(DATE FROM e.datetime) AS event_date
FROM 
  `proj-cdp-demo.demo_sfcc.klaviyo_event` e
JOIN 
  `proj-cdp-demo.demo_sfcc.klaviyo_metric` m
ON 
  e.metric_id = m.id
WHERE 
  m.name = 'Opened Email'
GROUP BY 
  email_subject, event_date
ORDER BY 
  open_count DESC
LIMIT 10;
