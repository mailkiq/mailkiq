WITH seg AS (:with_clause),
updated_campaign AS (
  UPDATE campaigns
  SET recipients_count = (SELECT count(*) FROM seg), sent_at = now()
  WHERE id = #{campaign_id}
  RETURNING *
)
INSERT INTO que_jobs (job_class, args)
SELECT
  'CampaignJob' AS job_class,
  json_build_array(:campaign_id, seg.id)
FROM seg
