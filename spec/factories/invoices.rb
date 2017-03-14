FactoryGirl.define do
  factory :invoice do
    status ["ordered","shipped","delivered"].sample
    customer
    merchant
  end
end
