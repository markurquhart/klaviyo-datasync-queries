SELECT 
  e.profile_id,
  e.datetime,
  m.name AS metric_name,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['Campaign Name']") AS campaign_name,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['message']") AS message_id,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['Subject']") AS email_subject,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['Recipient Email Address']") AS recipient_email,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['Client Name']") AS client_name,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['Client OS']") AS client_os,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['Client OS Family']") AS client_os_family,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['Client Type']") AS client_type,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['Inbox Provider']") AS inbox_provider,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['Email Domain']") AS email_domain,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['$message_interaction']") AS message_interaction,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['$internal']['Friendly From Domain']") AS friendly_from_domain,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['_ip']") AS ip_address,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['$internal']['Transmission ID']") AS transmission_id,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['User Agent']") AS user_agent,
  JSON_EXTRACT_SCALAR(e.event_properties, "$['machine_open']") AS machine_open
FROM 
  `proj-cdp-demo.demo_sfcc.klaviyo_event` e
JOIN 
  `proj-cdp-demo.demo_sfcc.klaviyo_metric` m
ON 
  e.metric_id = m.id
WHERE 
  m.name = 'Opened Email'
LIMIT 10;
