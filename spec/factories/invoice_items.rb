FactoryGirl.define do
  factory :invoice_item do
    quantity 1
    unit_price "10.00"
    item
    invoice
  end
end
