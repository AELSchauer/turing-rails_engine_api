class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.revenue_by_id(id)
    result = joins(invoices: [:invoice_items, :transactions])
      .where(id: id, transactions: {result: "success"})
      .group(:id)
      .sum("quantity * unit_price")

    {"revenue" => result[id]}

    # query = "SELECT merchants.id, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue
    #   FROM merchants
    #   INNER JOIN invoices
    #   ON merchants.id = invoices.merchant_id
    #   INNER JOIN invoice_items
    #   ON invoices.id = invoice_items.invoice_id
    #   INNER JOIN transactions
    #   ON invoices.id = transactions.invoice_id
    #   WHERE merchants.id = 27
    #     AND transactions.result = 'success'
    #   GROUP BY merchants.id"
    #
    # results = ActiveRecord::Base.connection.execute(query).first["revenue"]
  end

  def self.random
    order("RANDOM()").first
  end
end
