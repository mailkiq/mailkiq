Que.error_handler = proc do |error, job|
  Raven.capture_exception(error, extra: job)
end
