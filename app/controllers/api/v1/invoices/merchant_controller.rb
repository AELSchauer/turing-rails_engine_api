class Api::V1::Invoices::MerchantController < ApplicationController
  def show
    render json: Invoice.find(params[:invoice_id]).merchant
  end
end
