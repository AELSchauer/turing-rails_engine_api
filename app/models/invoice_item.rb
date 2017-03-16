class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  def self.random
    order("RANDOM()").first
  end
end
