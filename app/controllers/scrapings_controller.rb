class ScrapingsController < ApplicationController
  # POST /scrapings
  def create
    car = WebScraperService.scrape
    render json: car, status: :created
  end
end
