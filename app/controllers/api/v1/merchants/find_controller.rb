class Api::V1::Merchants::FindController < ApplicationController

  def index
    render json: Merchant.where(merchant_params)
  end

  def show
    render json: Merchant.find_by(merchant_params)
  end

  private

    def merchant_params
      params.permit(:name, :created_at, :updated_at)
    end

end
