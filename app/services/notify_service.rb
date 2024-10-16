class NotifyService
  NOTIFICATION_URL = 'http://localhost:3002/notifications'

  def self.call(title, body)
    # TODO: Mover para HabbitMQ
    uri = URI.parse(NOTIFICATION_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })

    request.body = { title: title, body: body }.to_json

    response = http.request(request)
    if response.is_a?(Net::HTTPSuccess)
      puts "Notificação enviada com sucesso!"
    else
      puts "Falha ao enviar a notificação. Código de resposta: #{response.code}"
    end
  end

end