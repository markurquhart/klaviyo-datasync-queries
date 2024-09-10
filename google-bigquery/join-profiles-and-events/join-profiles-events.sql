WITH metric_lookup AS (
  SELECT
    id AS metric_id,
    name AS metric_name
  FROM
    `proj-cdp-demo.demo_sfcc.klaviyo_metric`
  WHERE 
    integration_name = 'Salesforce Commerce Cloud' -- Filter for Salesforce Commerce Cloud metrics
)

SELECT 
    p.id,
    p.email,
    p.phone_number,
    p.first_name,
    p.last_name,
    JSON_EXTRACT_SCALAR(e.event_properties, "$['$currency_code']") AS currency_code,
    JSON_EXTRACT_SCALAR(e.event_properties, "$['$value']") AS value,
    JSON_EXTRACT_SCALAR(e.event_properties, "$['Collections']") AS Collections,
    JSON_EXTRACT_SCALAR(e.event_properties, "$['Item Count']") AS Item_Count,
    JSON_EXTRACT_SCALAR(e.event_properties, "$['Items']") AS Items,
    JSON_EXTRACT_SCALAR(e.event_properties, "$['OptedInToSmsOrderUpdates']") AS OptedInToSmsOrderUpdates,
    JSON_EXTRACT_SCALAR(e.event_properties, "$['Source Name']") AS Source_Name,
    JSON_EXTRACT_SCALAR(e.event_properties, "$['Total Discounts']") AS Total_Discounts,
    CASE 
        WHEN ml.metric_name = 'Placed Order' THEN 'Placed_Order'
        WHEN ml.metric_name = 'Started Checkout' THEN 'Started_Checkout'
        WHEN ml.metric_name = 'Ordered Product' THEN 'Ordered_Product'
        WHEN ml.metric_name = 'Viewed Category' THEN 'Viewed_Category'
        WHEN ml.metric_name = 'Add To Cart' THEN 'Add_To_Cart'
        WHEN ml.metric_name = 'Searched Site' THEN 'Searched_Site'
        ELSE 'Unknown'
    END AS event_name,
    e.datetime AS event_datetime
FROM 
    `proj-cdp-demo.demo_sfcc.klaviyo_event` e
JOIN 
    `proj-cdp-demo.demo_sfcc.klaviyo_profile` p ON e.profile_id = p.id
JOIN
    metric_lookup ml ON e.metric_id = ml.metric_id
WHERE 
    ml.metric_name IN ('Placed Order', 'Started Checkout', 'Ordered Product', 'Viewed Category', 'Add To Cart', 'Searched Site')
ORDER BY
    event_datetime DESC;
