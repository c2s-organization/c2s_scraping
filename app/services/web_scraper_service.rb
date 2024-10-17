require 'nokogiri'
require 'selenium-webdriver'

class WebScraperService
  SELENIUM_WAIT_TIMEOUT = 20
  FIREFOX_OPTIONS = '--disable-blink-features=AutomationControlled'

  def self.scrape(scrape_car)
    NotifyService.call("Scrape started", "Scraping task: #{scrape_car.task_id} with url: #{scrape_car.url}")
    driver = initialize_driver
    load_page(driver, scrape_car)

    document = parse_page_source(driver.page_source)

    data = extract_data(document)
    notify_services(scrape_car, data)

    data
  rescue Selenium::WebDriver::Error::TimeoutError => e
    handle_error(scrape_car, e)
  rescue Selenium::WebDriver::Error::NoSuchElementError => e
    handle_error(scrape_car, e)
  rescue => e
    handle_error(scrape_car, e)
  ensure
    driver&.quit
  end

  private

  def self.initialize_driver
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('--disable-blink-features=AutomationControlled')
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    Selenium::WebDriver.for(:firefox, options: options)
  end

  def self.load_page(driver, scrape_car)
    delay = rand(1..3)
    NotifyService.call("Scrape processing", "Scraping task: #{scrape_car.task_id} with url: #{scrape_car.url} in #{delay} seconds")
    sleep(delay)
    driver.navigate.to(scrape_car.url)
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
    friendly_message = "O carro que você está visualizando é um <b>#{data[:make]} #{data[:model]}</b> com o preço de <b>#{data[:price]}</b>. O modelo completo é: <b>#{data[:title]}</b>."
    TaskService.call(scrape_car.task_id, "completed", friendly_message)
    NotifyService.call("Scrape completed", "Scraping task: #{scrape_car.task_id} with url: #{scrape_car.url}")
  end

  def self.handle_error(scrape_car, error)
    TaskService.call(scrape_car.task_id, "failed")
    NotifyService.call("Scrape failed", "Scraping task: #{scrape_car.task_id} with url: #{scrape_car.url}")
    NotifyService.call("Scrape failed", "Scraping task: #{scrape_car.task_id} with error: #{error.message}")
  end
end
