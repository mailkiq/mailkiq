WITH interactions AS (
  SELECT
    campaign_id,
    COUNT(*) AS recipients_count,
    COUNT(NULLIF(opened_at IS null, true)) AS unique_opens_count,
    COUNT(NULLIF(clicked_at IS null, true)) AS unique_clicks_count
  FROM messages
  GROUP BY campaign_id
), deliveries AS (
  SELECT
    campaign_id,
    SUM(CASE type WHEN 0 THEN 1 ELSE 0 END) AS bounces_count,
    SUM(CASE type WHEN 1 THEN 1 ELSE 0 END) AS complaints_count
  FROM messages
  LEFT OUTER JOIN notifications ON notifications.message_id = messages.id
  GROUP BY campaign_id
)
UPDATE campaigns SET
  recipients_count = interactions.recipients_count,
  unique_opens_count = interactions.unique_opens_count,
  unique_clicks_count = interactions.unique_clicks_count,
  bounces_count = deliveries.bounces_count,
  complaints_count = deliveries.complaints_count
FROM interactions, deliveries
WHERE interactions.campaign_id = campaigns.id
AND deliveries.campaign_id = campaigns.id;
