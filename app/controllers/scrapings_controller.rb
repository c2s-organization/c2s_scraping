class ScrapingsController < ApplicationController

  def create
    @scrape_car = ScrapeCar.new(task_id: params[:task_id], url: params[:url])

    if @scrape_car.save
      WebScraperService.scrape(@scrape_car)

      render json: @scrape_car, status: :created
    else
      render json: { errors: @scrape_car.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
