class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :merchant_id

  belongs_to :customer
  belongs_to :merchant
end
