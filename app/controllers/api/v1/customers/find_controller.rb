class Api::V1::Customers::FindController < ApplicationController
  def index
    render json: Customer.where(find_params)
  end

  def show
    render json: Customer.find_by(find_params)
  end

  private

  def find_params
    params.permit(customer_attributes)
  end

  def customer_attributes
    Customer.new.attributes.keys
  end
end
