class Api::V1::Merchants::RevenueController < ApplicationController
  def index

  end
  def show
    render json: Merchant.revenue_by_id(params[:merchant_id].to_i)
  end
end
