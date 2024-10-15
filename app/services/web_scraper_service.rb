require 'nokogiri'
require 'open-uri'

class WebScraperService
  def self.scrape(url)
    page = Nokogiri::HTML(URI.open(url))
    year = page.at_css('strong#VehiclePrincipalInformationYear').text.strip
    kilometrage = page.at_css('strong#VehiclePrincipalInformatiOnodometer').text.strip
    price = page.at_css('strong#vehicleSendProposalPrice').text.strip

    { year: year, kilometrage: kilometrage, price: price }
  end
end
