class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    render json: Merchant.revenue_by_id(params[:merchant_id].to_i)
  end
end
