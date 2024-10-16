class TaskService
  require 'httparty'
  NOTIFICATION_URL = 'http://localhost:3000/api/scrapings'

  def self.call(task_id, status, scraped_data = nil)
    # TODO: Mover para HabbitMQ
    body = { task_id: task_id, status: status, scraped_data: scraped_data }

    HTTParty.put("#{NOTIFICATION_URL}/#{task_id}", body: body.to_json, headers: { 'Content-Type' => 'application/json' })
  end

end