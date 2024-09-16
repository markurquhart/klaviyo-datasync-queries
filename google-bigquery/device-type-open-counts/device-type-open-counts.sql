SELECT 
  JSON_EXTRACT_SCALAR(e.event_properties, "$['Client Name']") AS client_name,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['Client OS']") AS client_os,
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
  client_name, client_os, event_date
ORDER BY 
  event_date DESC, open_count DESC
LIMIT 10;
