class Api::V1::Invoices::FindController < ApplicationController

  def index
    render json: Invoice.where(find_params)
  end

  def show
    render json: Invoice.find_by(find_params)
  end

  private

    def find_params
      params.permit(:id, :status, :customer_id, :merchant_id, :created_at, :updated_at)
    end

end
