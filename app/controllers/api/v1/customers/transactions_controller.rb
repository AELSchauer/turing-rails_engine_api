class Api::V1::Customers::TransactionsController < ApplicationController
  def index
    render json: Customer.find(params["customer_id"]).transactions
  end
end
