class Api::V1::Items::BestDayController < ApplicationController
  def show
    results = Item.best_day(params[:item_id])
    best_day = results["created_at"].strftime("%FT%T.%LZ")
    render json: {"best_day" => best_day}
  end
end
