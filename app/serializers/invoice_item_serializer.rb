class InvoiceItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :unit_price, :item_id, :invoice_id, :created_at, :updated_at

  belongs_to :item
  belongs_to :invoice
end
