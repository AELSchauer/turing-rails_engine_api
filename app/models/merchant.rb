class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  def self.random
    order("RANDOM()").first
  end

  def self.revenue_by_id(id)
    result = joins(invoices: [:invoice_items, :transactions])
      .where(id: id, transactions: {result: "success"})
      .group(:id)
      .sum("quantity * unit_price")

    {"revenue" => result[id]}

    ## This query will deliver the same result as ActiveRecord,
    ## but not in the same format.
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
        # results = ActiveRecord::Base.connection.execute(query).first["revenue"]
  end

  def self.favorite_by_customer(customer_id)
    joins(invoices: :customer).where(customers: {id: customer_id}).group('merchants.id').order('count(merchants.id) DESC').limit(1).first

    ## This query will deliver the same result as ActiveRecord,
    ## but not in the same format.
        # query = "SELECT merchants.*
        #   FROM customers
        #   INNER JOIN invoices
        #           ON invoices.customer_id = customers.id
        #   INNER JOIN merchants
        #           ON merchants.id = invoices.merchant_id
        #   WHERE customers.id = #{customer_id}
        #   GROUP BY merchants.id
        #   ORDER BY count(merchants.id) DESC
        #   LIMIT 1"
        # results = ActiveRecord::Base.connection.execute(query).first
  end

  def self.total_revenue(date)
    joins(invoices: [:invoice_items, :transactions])
      .where(transactions: {result: "success"}, invoices: {created_at: date})
      .sum("quantity * unit_price")

    ## This query will deliver the same result as ActiveRecord,
    ## but not in the same format.
        # query = "SELECT sum(invoice_items.quantity * invoice_items.unit_price)
        #   FROM invoices
        #   INNER JOIN invoice_items
        #   ON invoices.id = invoice_items.invoice_id
        #   INNER JOIN transactions
        #   ON invoices.id = transactions.invoice_id
        #   WHERE transactions.result = 'success'
        #     AND invoices.created_at = '#{date}'"
        # results = ActiveRecord::Base.connection.execute(query).first
  end

  def self.favorite_customer(id)
    find(id).customers.joins(invoices: [:transactions])
    .where(transactions: {result: "success"})
    .group('customers.id')
    .order('count(invoices.merchant_id) DESC')
    .first
  end
end
