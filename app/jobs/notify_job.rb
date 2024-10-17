class NotifyJob < ApplicationJob
  queue_as :scrape_notify

  retry_on StandardError, wait: 30.seconds, attempts: 5

  def perform(title, body)
    NotifyService.call(title, body)
  end
end
