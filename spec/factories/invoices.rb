FactoryGirl.define do
  factory :invoice do
    status ["unpaid","paid","shipped"].sample
    customer
    merchant

    factory :invoice_with_invoice_items do
      transient do
        invoice_items_count 3
      end
      after(:create) do |invoice, evaluator|
        create_list(:invoice_item, evaluator.invoice_items_count, invoice: invoice)
      end
    end
    factory :invoice_with_transactions do
      transient do
        transactions_count 3
      end
      after(:create) do |invoice, evaluator|
        create_list(:transaction, evaluator.transactions_count, invoice: invoice)
      end
    end
  end
end