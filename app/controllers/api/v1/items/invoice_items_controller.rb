class Api::V1::Items::InvoiceItemsController < ApplicationController
  def index
    render json: Item.find(params["item_id"]).invoice_items
  end
end
