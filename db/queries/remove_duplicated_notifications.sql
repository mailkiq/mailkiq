WITH dups AS (
  SELECT COUNT(*) AS count, array_agg(id) AS ids FROM notifications
  GROUP BY data
  HAVING COUNT(*) >= 2
) DELETE FROM notifications WHERE id IN (SELECT unnest(ids[2:count]) FROM dups);
