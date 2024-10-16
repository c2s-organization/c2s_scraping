require 'swagger_helper'

RSpec.describe 'Scrapings API', type: :request do
  path '/scrapings' do
    post 'Creates a Scraping Task' do
      tags 'Scrapings'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :scraping, in: :body, schema: {
        '$ref' => '#/components/schemas/ScrapeCarCreate'
      }

      response '201', 'Scraping task created successfully' do
        let(:scraping) { { task_id: 123, url: 'https://example.com/car-listing' } }

        before do
          # Mock do método scrape para evitar execução real
          allow(WebScraperService).to receive(:scrape).with(an_instance_of(ScrapeCar)).and_return(true)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['task_id']).to eq(123)
          expect(data['url']).to eq('https://example.com/car-listing')
          expect(data['id']).not_to be_nil

          # Verifica se o método scrape foi chamado uma vez
          expect(WebScraperService).to have_received(:scrape).once
        end
      end

      response '422', 'Unprocessable Entity' do
        let(:scraping) { { task_id: nil, url: 'invalid-url' } }

        before do
          allow(WebScraperService).to receive(:scrape).never
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to include("Task can't be blank", "Url must be a valid Url")
        end
      end
    end
  end
end
