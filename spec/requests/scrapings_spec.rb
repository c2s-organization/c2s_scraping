require 'rails_helper'

RSpec.describe 'Scrapings API', type: :request do
  let(:html) { File.read(Rails.root.join('spec/fixtures/webmotors_page.html')) }

  before do
    # allow(URI).to receive(:open).and_return(html)
    # allow(HTTParty).to receive(:post)
  end

  describe 'POST /scrapings' do
    it 'realiza o scraping e retorna os dados do carro' do
      post '/scrapings'
      expect(response).to have_http_status(:created)

      car = Car.last
      expect(response.body).to include(car.make)
      expect(response.body).to include(car.model)
      expect(response.body).to include(car.year)
      expect(response.body).to include(car.price)
    end
  end
end
