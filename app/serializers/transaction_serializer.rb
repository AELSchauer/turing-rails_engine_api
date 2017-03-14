class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :invoice_id, :credit_card_number, :result

  belongs_to :invoice
end
