require 'rails_helper'

RSpec.describe ScrapingsController, type: :controller do
  let(:valid_params) { { task_id: '1', url: 'https://example.com/car' } }
  let(:scrape_car) { instance_double(ScrapeCar, id: 1, task_id: valid_params[:task_id], url: valid_params[:url]) }

  before do
    allow(ScrapeCar).to receive(:new).and_return(scrape_car)
    allow(scrape_car).to receive(:save).and_return(true)
    allow(WebScraperService).to receive(:scrape)  # Stub WebScraperService
  end

  describe 'POST #create' do
    context 'when ScrapeCar is successfully created' do
      before do
        post :create, params: valid_params
      end

      it 'saves a new ScrapeCar' do
        expect(ScrapeCar).to have_received(:new).with(task_id: valid_params[:task_id], url: valid_params[:url])
        expect(scrape_car).to have_received(:save)
      end

      it 'calls WebScraperService.scrape' do
        expect(WebScraperService).to have_received(:scrape).with(scrape_car)
      end

      it 'returns status created' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the scrape_car in the response body' do
        expect(response.body).to eq(scrape_car.to_json)
      end
    end

    context 'when ScrapeCar fails to save' do
      before do
        allow(scrape_car).to receive(:save).and_return(false)
        post :create, params: valid_params
      end

      it 'does not call WebScraperService.scrape' do
        expect(WebScraperService).not_to have_received(:scrape)
      end

      it 'does not return status created' do
        expect(response).not_to have_http_status(:created)
      end
    end
  end
end
