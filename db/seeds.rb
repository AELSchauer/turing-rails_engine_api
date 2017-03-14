require 'csv'
require 'date'

file = "db/csv/customers.csv"
csv_count = CSV.read(file).count - 1
CSV.foreach(file, headers: true) do |row|
  row.delete("id")
  Customer.create(row.to_h)
end
object_count = Customer.count
puts "Customer -- #{object_count} #{csv_count} #{object_count == csv_count}"

file = "db/csv/merchants.csv"
csv_count = CSV.read(file).count - 1
CSV.foreach(file, headers: true) do |row|
  row.delete("id")
  Merchant.create(row.to_h)
end
object_count = Merchant.count
puts "Merchant -- #{object_count} #{csv_count} #{object_count == csv_count}"

file = "db/csv/invoices.csv"
csv_count = CSV.read(file).count - 1
CSV.foreach(file, headers: true) do |row|
  merchant_id = row["merchant_id"]
  row.delete("id")
  row.delete("merchant_id")
  Merchant.find(merchant_id).invoices.create(row.to_h)
end
object_count = Invoice.count
puts "Invoice -- #{object_count} #{csv_count} #{object_count == csv_count}"

file = "db/csv/items.csv"
csv_count = CSV.read(file).count - 1
CSV.foreach(file, headers: true) do |row|
  merchant_id = row["merchant_id"]
  row["unit_price"] = (row["unit_price"].to_f / 1000).round(2)
  row.delete("id")
  row.delete("merchant_id")
  Merchant.find(merchant_id).items.create(row.to_h)
end
object_count = Item.count
puts "Item -- #{object_count} #{csv_count} #{object_count == csv_count}"

file = "db/csv/transactions.csv"
csv_count = CSV.read(file).count - 1
CSV.foreach(file, headers: true) do |row|
  invoice_id = row["invoice_id"]
  row.delete("id")
  row.delete("invoice_id")
  row["credit_card_expiration_date"] = Date.new(2018,3)
  Invoice.find(invoice_id).transactions.create(row.to_h)
end
object_count = Transaction.count
puts "Transaction -- #{object_count} #{csv_count} #{object_count == csv_count}"

file = "db/csv/invoice_items.csv"
csv_count = CSV.read(file).count - 1
CSV.foreach(file, headers: true) do |row|
  invoice_id = row["invoice_id"]
  item_id = row["item_id"]
  row.delete("id")
  row.delete("invoice_id")
  row.delete("item_id")
  row["unit_price"] = (row["unit_price"].to_f / 1000).round(2)
  Invoice.find(invoice_id).invoice_items.create(row.to_h)
end
object_count = InvoiceItem.count
puts "InvoiceItem -- #{object_count} #{csv_count} #{object_count == csv_count}"
