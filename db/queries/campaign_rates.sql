SELECT
  campaign_id,
  COUNT(NULLIF(opened_at IS null, true)) AS unique_opens_count,
  COUNT(NULLIF(clicked_at IS null, true)) AS unique_clicks_count
FROM messages
GROUP BY campaign_id;
