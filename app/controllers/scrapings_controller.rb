class ScrapingsController < ApplicationController
  # POST /scrapings
  def create
    car = WebScraperService.scrape(params[:url])
    render json: car, status: :created
  end
end
