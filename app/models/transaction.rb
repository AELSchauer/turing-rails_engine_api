class Transaction < ApplicationRecord
  belongs_to :invoice

  def customer
    invoice.customer
  end
end
