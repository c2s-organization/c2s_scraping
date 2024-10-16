class ScrapingsController < ApplicationController

  def create
    @scrape_car = ScrapeCar.new(task_id: params[:task_id], url: params[:url])

    if @scrape_car.save
      WebScraperService.scrape(@scrape_car)

      render json: @scrape_car, status: :created
    end
  end
end
