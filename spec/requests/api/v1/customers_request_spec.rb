require 'rails_helper'

describe "Customers API" do
  it "sends a list of customers" do
    create_list(:customer, 3)

    get '/api/v1/customers'

    expect(response).to be_success

    customers = JSON.parse(response.body)

    expect(customers.count).to eq(3)
  end

  it "can get one customer by its id" do
    id = create(:customer).id

    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)

    expect(response).to be_success
    expect(customer["id"]).to eq(id)
  end

  it "serializes attributes" do
    customer_1 = Customer.create(first_name: "Vincent", last_name: "Vega", created_at: "1234", updated_at: "5678")
    expect(customer_1).to have_attributes(:first_name => "Vincent")
    expect(customer_1).to have_attributes(:last_name => "Vega")
    expect(customer_1).to_not have_attributes(:updated_at => "1234")
    expect(customer_1).to_not have_attributes(:created_at => "5678")
  end

end
