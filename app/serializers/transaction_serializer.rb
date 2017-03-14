class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :credit_card_number, :result, :invoice_id, :created_at, :updated_at

  belongs_to :invoice
end
