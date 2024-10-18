require 'rails_helper'

RSpec.describe TaskService do
  include ActiveJob::TestHelper

  let(:task_id) { 1 }
  let(:status) { 'completed' }
  let(:scraped_data) { { make: 'Ford', model: 'Fiesta' } }
  let(:notification_url) { "#{TaskService::NOTIFICATION_URL}/#{task_id}" }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:body_data) { { task_id: task_id, status: status, scraped_data: scraped_data }.to_json }
  let(:response) { instance_double(HTTParty::Response) }

  describe '.call' do
    before do
      allow(HTTParty).to receive(:put).with(notification_url, body: body_data, headers: headers).and_return(response)
    end

    context 'when the PUT request is successful' do
      it 'sends the correct request and returns a successful response' do
        allow(response).to receive(:success?).and_return(true)

        result = TaskService.call(task_id, status, scraped_data)

        expect(HTTParty).to have_received(:put).with(notification_url, body: body_data, headers: headers)
        expect(result.success?).to be(true)
      end
    end

    context 'when the PUT request fails' do
      it 'sends the correct request and returns an unsuccessful response' do
        allow(response).to receive(:success?).and_return(false)

        result = TaskService.call(task_id, status, scraped_data)

        expect(HTTParty).to have_received(:put).with(notification_url, body: body_data, headers: headers)
        expect(result.success?).to be(false)
      end
    end
  end
end
