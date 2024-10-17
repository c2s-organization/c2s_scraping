class TaskService
  require 'httparty'
  NOTIFICATION_URL = "#{ENV["URL_MS_TASK"]}/api/scrapings"

  def self.call(task_id, status, scraped_data = nil)
    body = { task_id: task_id, status: status, scraped_data: scraped_data }

    HTTParty.put("#{NOTIFICATION_URL}/#{task_id}", body: body.to_json, headers: { 'Content-Type' => 'application/json' })

    NotifyJob.perform_later("Task sent", "Task #{task_id} was #{status}")
  end

end