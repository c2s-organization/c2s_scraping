require 'rails_helper'

RSpec.describe NotifyService do
  let(:title) { 'Test Notification' }
  let(:body) { 'This is a test notification body.' }
  let(:notification_url) { NotifyService::NOTIFICATION_URL }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:body_data) { { title: title, body: body }.to_json }
  let(:response) { instance_double(HTTParty::Response) }

  describe '.call' do
    before do
      allow(HTTParty).to receive(:post).with(notification_url, body: body_data, headers: headers).and_return(response)
    end

    context 'when the POST request is successful' do
      it 'returns a successful response' do
        allow(response).to receive(:success?).and_return(true)

        result = NotifyService.call(title, body)

        expect(HTTParty).to have_received(:post).with(notification_url, body: body_data, headers: headers)
        expect(result.success?).to be(true)
      end
    end

    context 'when the POST request fails' do
      it 'returns an unsuccessful response' do
        allow(response).to receive(:success?).and_return(false)

        result = NotifyService.call(title, body)

        expect(HTTParty).to have_received(:post).with(notification_url, body: body_data, headers: headers)
        expect(result.success?).to be(false)
      end
    end
  end
end
