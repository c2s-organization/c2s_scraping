require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'json'

class WebScraperService
  NOTIFICATION_URL = 'http://localhost:3002/notifications'

  def self.scrape(url)
    page = Nokogiri::HTML(URI.open(url))

    make = page.at_css('h1#VehicleBasicInformationTitle').children[0].text.strip
    model = page.at_css('h1#VehicleBasicInformationTitle strong').text.strip
    price = page.at_css('strong#vehicleSendProposalPrice').text.strip
    title = page.at_css('h1#VehicleBasicInformationTitle').text.strip

    data = { make: make, model: model, price: price, title: title }

    body = "Marca: #{make}, Modelo: #{model}, Preço: #{price}"

    Car.create(make: make, model: model, price: price)

    notify_microservice(title, body)

    data
  end

  def self.notify_microservice(title, body)
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