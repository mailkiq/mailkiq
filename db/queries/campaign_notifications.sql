SELECT campaign_id, type, COUNT(*) AS count FROM messages
LEFT OUTER JOIN notifications ON notifications.message_id = messages.id
GROUP BY campaign_id, type ORDER BY campaign_id, type NULLS LAST;
