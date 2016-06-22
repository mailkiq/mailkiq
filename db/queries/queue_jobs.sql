WITH seg AS (:with)
INSERT INTO que_jobs (job_class, args)
SELECT
  'CampaignJob' AS job_class,
  json_build_array(:campaign_id, seg.id)
FROM seg
