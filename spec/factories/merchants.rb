require 'faker'

FactoryGirl.define do
  factory :merchant do
    name Faker::Company.name
  end
end
