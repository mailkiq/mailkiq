WITH states AS (
  SELECT (
    CASE
    WHEN data ? 'bouncedRecipients' THEN 1
    WHEN data ? 'complainedRecipients' THEN 2
    WHEN data ? 'processingTimeMillis' THEN 3
    ELSE 0
    END
  ) AS state, message_id FROM notifications
)
UPDATE messages SET state = states.state FROM states
WHERE states.message_id = messages.id;
