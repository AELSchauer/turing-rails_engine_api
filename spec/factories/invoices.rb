FactoryGirl.define do
  factory :invoice do
    status ["unpaid","paid","shipped"].sample
    customer
    merchant
  end
end
