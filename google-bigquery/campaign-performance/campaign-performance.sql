WITH metric_lookup AS (
  SELECT
    id AS metric_id,
    name AS metric_name
  FROM
    `proj-cdp-demo.demo_sfcc.klaviyo_metric`
)
SELECT
  campaign_name,
  MAX(subject_line) AS subject_line,
  SUM(CASE WHEN ml.metric_name = 'Received Email' THEN count ELSE 0 END) AS `Received Email`,
  SUM(CASE WHEN ml.metric_name = 'Clicked Email' THEN count ELSE 0 END) AS `Clicked Email`,
  SUM(CASE WHEN ml.metric_name = 'Opened Email' THEN count ELSE 0 END) AS `Opened Email`,
  SUM(CASE WHEN ml.metric_name NOT IN ('Received Email', 'Clicked Email', 'Opened Email') THEN count ELSE 0 END) AS `Unknown Metric`
FROM
(
  SELECT 
    ke.metric_id,
    JSON_EXTRACT_SCALAR(ke.event_properties, "$['Campaign Name']") as campaign_name,
    JSON_EXTRACT_SCALAR(ke.event_properties, "$['Subject']") as subject_line,
    COUNT(DISTINCT ke.profile_id) as count
  FROM 
    `proj-cdp-demo.demo_sfcc.klaviyo_event` ke
  WHERE 
    JSON_EXTRACT_SCALAR(ke.event_properties, "$['Campaign Name']") LIKE 'Daily Newsletter%'
  GROUP BY 
    1, 2, 3
) derived
JOIN 
  metric_lookup ml
ON 
  derived.metric_id = ml.metric_id
GROUP BY
  campaign_name
ORDER BY 
  SUM(CASE WHEN ml.metric_name = 'Received Email' THEN count ELSE 0 END) DESC;
