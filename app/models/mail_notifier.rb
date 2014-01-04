class MailNotifier

  # optional, only needed if you pass config options to the job
  def initialize(options = {})
    @options = options
  end

  def run()
    AdminNotifier.entries_need_moderation
  end

  def on_error(exception)
    Rails.logger.warn("Cron job failed: #{exception.inspect}")
  end

end