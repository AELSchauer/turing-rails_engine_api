require 'csv'
require 'date'

class Uploader

  def initialize(file_name)
    @type = file_name
    @file = "db/csv/#{file_name}.csv"
    @object = object_index[file_name]
  end

  def object_index
    {
      customers: Customer,
      invoices: Invoice,
      invoice_items: InvoiceItem,
      items: Item,
      merchants: Merchant,
      transactions: Transaction
    }
  end

  def table
    CSV.read(@file, :headers => true)
  end

  def upload_table
    upload_table = table
    upload_table.delete("id")
    upload_table
  end

  def table_count
    @object.count.to_s.rjust(6)
  end

  def csv_count
    table.count.to_s.rjust(6)
  end

  def upload
    case @type
    when :customers
      upload_customer
    when :invoices
      upload_invoice
    when :invoice_items
      upload_invoice_item
    when :items
      upload_item
    when :merchants
      upload_merchant
    when :transactions
      upload_transaction
    end
    upload_complete
  end

  def convert_to_currency(number)
    (number.to_f / 1000).round(2)
  end

  def name
    @type.to_s.rjust(13)
  end

  def upload_complete
    puts "#{name} -- #{table_count == csv_count ? "SUCCESS" : "FAILURE"} -- #{table_count} #{csv_count}"
  end

  def upload_customer
    upload_table.each do |row|
      Customer.create(row.to_h)
    end
  end

  def upload_invoice
    upload_table.each do |row|
      merchant = Merchant.find(row["merchant_id"])
      row.delete("merchant_id")
      merchant.invoices.create(row.to_h)
    end
  end

  def upload_invoice_item
    upload_table.each do |row|
      invoice = Invoice.find(row["invoice_id"])
      row.delete("invoice_id")
      row["unit_price"] = convert_to_currency(row["unit_price"])
      invoice.invoice_items.create(row.to_h)
    end
  end

  def upload_item
    upload_table.each do |row|
      merchant = Merchant.find(row["merchant_id"])
      row.delete("merchant_id")
      row["unit_price"] = convert_to_currency(row["unit_price"])
      merchant.items.create(row.to_h)
    end
  end

  def upload_merchant
    upload_table.each do |row|
      Merchant.create(row.to_h)
    end
  end

  def upload_transaction
    upload_table.each do |row|
      invoice = Invoice.find(row["invoice_id"])
      row.delete("invoice_id")
      row["credit_card_expiration_date"] = Date.new(2018,3)
      invoice.transactions.create(row.to_h)
    end
  end
end


files = [:customers, :merchants, :invoices, :items, :transactions, :invoice_items ]

files.each do |file_name|
  file = Uploader.new(file_name)
  file.upload
end
