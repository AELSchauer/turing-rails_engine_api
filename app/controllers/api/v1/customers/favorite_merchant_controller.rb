class Api::V1::Customers::FavoriteMerchantController < ApplicationController
  def show
    render json: Merchant.favorite_by_customer(params[:customer_id].to_i)
  end
end
