require 'nokogiri'
require 'open-uri'

class WebScraperService
  WEBMOTORS_URL = 'https://www.webmotors.com.br/comprar/peugeot/208/16-griffe-16v-flex-4p-automatico/4-portas/2020/52049140?pos=a52049140g:&np=1&ct=1840177'

  def self.scrape
    # Realizando a requisição para obter a página HTML
    html = URI.open(WEBMOTORS_URL)
    doc = Nokogiri::HTML(html)

    # Coletando os dados da página
    make = doc.css('.make-model').text.strip
    model = doc.css('.version').text.strip
    year = doc.css('.vehicle-year').text.strip
    price = doc.css('.price').text.strip

    # Salvando os dados no banco de dados
    car = Car.create(make: make, model: model, year: year, price: price)

    # Chamando o serviço de notificação
    notify_service(car)

    car
  end

  def self.notify_service(car)
    # Enviando notificação para o microserviço de notificações
    notification_body = "Novo carro scrapeado: #{car.make} #{car.model} - Ano #{car.year}, Preço: #{car.price}"
    HTTParty.post('http://localhost:3002/notifications', body: {
      notification: { title: 'Carro scrapeado com sucesso', body: notification_body }
    })
  end
end
