UPDATE messages SET state = (
  CASE
  WHEN data ? 'bouncedRecipients' THEN 1
  WHEN data ? 'complainedRecipients' THEN 2
  END
) FROM notifications
WHERE (data ? 'bouncedRecipients' OR data ? 'complainedRecipients')
AND messages.id = notifications.message_id;
