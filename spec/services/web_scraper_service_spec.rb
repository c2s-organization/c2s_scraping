require 'rails_helper'
require 'nokogiri'
require 'selenium-webdriver'

RSpec.describe WebScraperService do
  let(:scrape_car) { double("ScrapeCar", task_id: 1, url: "http://example.com") }
  let(:driver) { instance_double(Selenium::WebDriver::Driver) }
  let(:navigate) { instance_double(Selenium::WebDriver::Navigation) }
  let(:wait) { instance_double(Selenium::WebDriver::Wait) }
  let(:document) { Nokogiri::HTML('<html><h1 id="VehicleBasicInformationTitle">Ford <strong>Mustang</strong> <span>2020</span></h1><div id="vehicleSendProposalPrice">$30,000</div></html>') }
  let(:page_source) { document.to_html }

  before do
    allow(Selenium::WebDriver).to receive(:for).and_return(driver)
    allow(driver).to receive(:navigate).and_return(navigate)
    allow(driver).to receive(:page_source).and_return(page_source)
    allow(driver).to receive(:quit)
    allow(navigate).to receive(:to).with(scrape_car.url)
    allow(Selenium::WebDriver::Wait).to receive(:new).and_return(wait)
    allow(wait).to receive(:until)
    allow(NotifyJob).to receive(:perform_later)
    allow(TaskJob).to receive(:perform_later)
    allow(WebScraperService).to receive(:sleep)
  end

  describe '.scrape' do
    context 'when the page loads successfully' do
      it 'calls the NotifyJob and TaskJob with the correct arguments' do
        result = WebScraperService.scrape(scrape_car)

        expect(NotifyJob).to have_received(:perform_later).with("Scrape started", "Scraping task: 1 with url: http://example.com").ordered
        expect(NotifyJob).to have_received(:perform_later).with("Scrape completed", "Scraping task: 1 with url: http://example.com").ordered
        expect(TaskJob).to have_received(:perform_later).with(1, "completed", /Ford Mustang/)

        expect(result[:make]).to eq("Ford")
        expect(result[:model]).to eq("Mustang")
        expect(result[:price]).to eq("$30,000")
      end
    end

    context 'when a timeout error occurs' do
      it 'handles the error and calls NotifyJob and TaskJob with failure' do
        allow(wait).to receive(:until).and_raise(Selenium::WebDriver::Error::TimeoutError)

        expect {
          WebScraperService.scrape(scrape_car)
        }.not_to raise_error

        expect(NotifyJob).to have_received(:perform_later).with("Scrape failed", "Scraping task: 1 with url: http://example.com")
        expect(TaskJob).to have_received(:perform_later).with(1, "failed")
      end
    end
  end
end
