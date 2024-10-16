require 'nokogiri'
require 'selenium-webdriver'

class WebScraperService
  def self.scrape(url)
    # FIXME: Problema com o captcha
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('--disable-blink-features=AutomationControlled') # Evita que o site saiba que está sendo acessado por automação
    driver = Selenium::WebDriver.for :firefox, options: options
    driver.navigate.to url
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { driver.find_element(css: 'h1#VehicleBasicInformationTitle') }

    page_source = driver.page_source
    document = Nokogiri::HTML(page_source)

    make = document.at_css('h1#VehicleBasicInformationTitle').text.split.first
    model = document.css('h1#VehicleBasicInformationTitle strong').text
    price = document.css('#vehicleSendProposalPrice').text
    title = document.at_css('h1#VehicleBasicInformationTitle strong').text.strip

    data = { make: make, model: model, price: price, title: title }

    driver.action.move_to(driver.find_element(css: 'body')).perform

    driver.quit

    NotifyService.call(title, data[:price])

    data
  end
end