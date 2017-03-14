FactoryGirl.define do
  factory :invoice do
    status "MyString"
    customer
    merchant
  end
end
