class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.random
    order("RANDOM()").first
  end

  def self.best_day(id)
    Invoice.select(:created_at)
      .joins(invoice_items: :item)
      .where(items: {id: id})
      .group(:created_at)
      .order("sum(invoice_items.quantity) DESC, invoices.created_at DESC")
      .limit(1)
      .first

    # query = "SELECT invoices.created_at
    #   FROM items
    #   INNER JOIN invoice_items
    #           ON invoice_items.item_id = items.id
    #   INNER JOIN invoices
    #           ON invoices.id = invoice_items.invoice_id
    #   WHERE items.id = #{id}
    #   GROUP BY invoices.created_at
    #   ORDER BY sum(invoice_items.quantity) DESC, invoices.created_at DESC
    #   LIMIT 1
    #   ;"

    # results = ActiveRecord::Base.connection.execute(query).first
  end
  
  def self.most_revenue(quantity)
    joins(:invoice_items, invoices: [:transactions])
    .where(transactions: {result: "success"})
    .group("items.id")
    .order("sum(invoice_items.quantity * invoice_items.unit_price) DESC")
    .limit(quantity)
  end
end
