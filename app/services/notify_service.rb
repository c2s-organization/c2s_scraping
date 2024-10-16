class NotifyService
  require 'httparty'

  NOTIFICATION_URL = 'http://localhost:3002/notifications'

  def self.call(title, body)
    # TODO: Mover para HabbitMQ
    body = { title: title, body: body }

    HTTParty.post(NOTIFICATION_URL, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
  end

end