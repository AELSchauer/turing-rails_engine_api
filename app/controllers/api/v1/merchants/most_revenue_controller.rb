class Api::V1::Merchants::MostRevenueController < ApplicationController
  def index
    binding.pry
    results = Merchant.most_revenue(params[:quantity])
    render json: {}
  end
end