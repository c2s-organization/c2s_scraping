require 'nokogiri'
require 'selenium-webdriver'

class WebScraperService
  SELENIUM_WAIT_TIMEOUT = 10
  FIREFOX_OPTIONS = '--disable-blink-features=AutomationControlled'

  def self.scrape(scrape_car)
    driver = initialize_driver
    load_page(driver, scrape_car.url)

    document = parse_page_source(driver.page_source)

    data = extract_data(document)
    notify_services(scrape_car, data)

    data
  rescue StandardError => e
    handle_error(scrape_car, e)
  ensure
    driver&.quit
  end

  private

  def self.initialize_driver
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument(FIREFOX_OPTIONS)
    Selenium::WebDriver.for(:firefox, options: options)
  end

  def self.load_page(driver, url)
    driver.navigate.to(url)
    wait = Selenium::WebDriver::Wait.new(timeout: SELENIUM_WAIT_TIMEOUT)
    wait.until { driver.find_element(css: 'h1#VehicleBasicInformationTitle') }
  end

  def self.parse_page_source(page_source)
    Nokogiri::HTML(page_source)
  end

  def self.extract_data(document)
    make = document.at_css('h1#VehicleBasicInformationTitle').text.split.first
    model = document.at_css('h1#VehicleBasicInformationTitle strong').text
    price = document.css('#vehicleSendProposalPrice').text
    title = "#{make}, #{model}, #{price}, #{document.at_css('h1#VehicleBasicInformationTitle span').text.strip}"

    {
      make: make,
      model: model,
      price: price,
      title: title
    }
  end

  def self.notify_services(scrape_car, data)
    NotifyService.call(data[:title], data[:price])
    TaskService.call(scrape_car.task_id, "completed", data)
  end

  def self.handle_error(scrape_car, error)
    TaskService.call(scrape_car.task_id, "failed")
    Rails.logger.error("Web scraping failed for task #{scrape_car.task_id}: #{error.message}")
  end
end
