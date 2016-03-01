UPDATE campaigns SET
  recipients_count = counters.recipients_count,
  unique_opens_count = counters.unique_opens_count,
  unique_clicks_count = counters.unique_clicks_count
FROM (
  SELECT
    campaign_id,
    COUNT(*) AS recipients_count,
    COUNT(NULLIF(opened_at IS null, true)) AS unique_opens_count,
    COUNT(NULLIF(clicked_at IS null, true)) AS unique_clicks_count
  FROM messages
  GROUP BY campaign_id
) AS counters WHERE counters.campaign_id = campaigns.id;
