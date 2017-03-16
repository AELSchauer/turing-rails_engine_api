class Api::V1::Invoices::RandomController < ApplicationController
  def show
    render json: Invoice.random
  end
end
