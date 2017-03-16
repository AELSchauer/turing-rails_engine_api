class Api::V1::Items::BestDayController < ApplicationController
  def show
    render json: Invoice.best_day_for_item(params[:item_id])
  end
end
