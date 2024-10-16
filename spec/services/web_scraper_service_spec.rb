require 'rails_helper'

RSpec.describe WebScraperService do
  let(:scrape_car) { double('ScrapeCar', task_id: 1, url: Rails.root.join('spec/fixtures/webmotors_page.html').to_s) }
  let(:mock_driver) { instance_double(Selenium::WebDriver::Driver) }
  let(:mock_element) { instance_double(Selenium::WebDriver::Element) }
  let(:mock_wait) { instance_double(Selenium::WebDriver::Wait) }
  let(:page_source) { File.read(Rails.root.join('spec/fixtures/webmotors_page.html')) }

  before do
    allow(Selenium::WebDriver::Firefox::Options).to receive(:new).and_return(double(add_argument: true))
    allow(Selenium::WebDriver).to receive(:for).and_return(mock_driver)
    allow(mock_driver).to receive(:navigate).and_return(double(to: true))
    allow(mock_driver).to receive(:page_source).and_return(page_source)
    allow(mock_driver).to receive(:quit)

    allow(Selenium::WebDriver::Wait).to receive(:new).and_return(mock_wait)
    allow(mock_wait).to receive(:until).and_return(mock_element)

    allow(mock_element).to receive(:find_element).and_return(mock_element)
    allow(mock_element).to receive(:text).and_return('CHEVROLET')

    allow(NotifyService).to receive(:call)
    allow(TaskService).to receive(:call)
  end

  describe '.scrape' do
    context 'when scraping is successful' do
      it 'calls NotifyService and TaskService with the correct data' do
        result = WebScraperService.scrape(scrape_car)

        expect(result[:make]).to eq('PEUGEOT')
        expect(result[:model]).to eq('208')
        expect(result[:price]).to eq('R$ 70.990')
        expect(result[:title]).to eq('PEUGEOT, 208, R$ 70.990, 1.6 GRIFFE 16V FLEX 4P AUTOMÁTICO')

        expect(NotifyService).to have_received(:call).with("PEUGEOT, 208, R$ 70.990, 1.6 GRIFFE 16V FLEX 4P AUTOMÁTICO", "R$ 70.990")
        expect(TaskService).to have_received(:call).with(scrape_car.task_id, 'completed', result)
      end
    end

    context 'when scraping fails' do
      before do
        allow(mock_driver).to receive(:page_source).and_raise(StandardError.new('Error scraping page'))
      end

      it 'calls TaskService with failed status' do
        WebScraperService.scrape(scrape_car)

        expect(TaskService).to have_received(:call).with(scrape_car.task_id, 'failed')
      end
    end
  end
end
