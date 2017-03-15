class Api::V1::Invoices::FindController < ApplicationController
  def index
    # render json: Invoice.
  end

  def show
    render json: Invoice.find_by(find_params)
  end

  private

  def find_params
    params.permit(invoice_attributes)
  end

  def invoice_attributes
    Invoice.new.attributes.keys
  end
end
