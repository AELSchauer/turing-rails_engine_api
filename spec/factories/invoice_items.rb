FactoryGirl.define do
  factory :invoice_item do
    quantity 1
    unit_price "9.99"
    item nil
    invoice nil
  end
end
