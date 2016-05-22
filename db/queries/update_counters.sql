WITH counters AS (
  SELECT
    campaign_id,
    COUNT(DISTINCT subscriber_id) AS recipients_count,
    SUM(CASE state WHEN 1 THEN 1 ELSE 0 END) AS bounces_count,
    SUM(CASE state WHEN 2 THEN 1 ELSE 0 END) AS complaints_count,
    COUNT(NULLIF(opened_at IS null, true)) AS unique_opens_count,
    COUNT(NULLIF(clicked_at IS null, true)) AS unique_clicks_count
  FROM messages
  GROUP BY campaign_id
)
UPDATE campaigns SET
  recipients_count = counters.recipients_count,
  unique_opens_count = counters.unique_opens_count,
  unique_clicks_count = counters.unique_clicks_count,
  bounces_count = counters.bounces_count,
  complaints_count = counters.complaints_count
FROM counters
WHERE counters.campaign_id = campaigns.id;
