class ApplicationJob < Que::Job
  def _run
    Appsignal.monitor_single_transaction(
      'perform_job.que',
      class: attrs[:job_class],
      method: 'run',
      metadata: {
        id: attrs[:job_id],
        queue: attrs[:queue],
        priority: attrs[:priority],
        attempts: attrs[:error_count]
      },
      params: attrs[:args],
      queue_start: attrs[:run_at]
    ) do
      super
    end
  end
end
