class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.random
    order("RANDOM()").first
  end

  def self.most_revenue(quantity)
    joins(:invoice_items, invoices: [:transactions])
    .where(transactions: {result: "success"})
    .group("items.id")
    .order("sum(invoice_items.quantity * invoice_items.unit_price) DESC")
    .limit(quantity)
  end
end
