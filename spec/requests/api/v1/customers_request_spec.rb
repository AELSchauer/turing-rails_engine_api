require 'rails_helper'

describe "Customers API" do
  it "sends a list of customers" do
    create_list(:customer, 3)

    get "/api/v1/customers"

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
    created = "2017-01-01T00:00:00.000Z"
    updated = "2017-02-01T00:00:00.000Z"
    customer_1 = Customer.create(
      first_name: "Vincent",
      last_name: "Vega",
      created_at: created,
      updated_at: updated
    )
    expect(customer_1).to have_attributes(first_name: "Vincent")
    expect(customer_1).to have_attributes(last_name: "Vega")
    expect(customer_1).to_not have_attributes(created_at: created)
    expect(customer_1).to_not have_attributes(updated_at: updated)
  end

  context "find method" do
    it "can find a customer by its id" do
      customer1 = create(:customer)
      customer2 = create(:customer)

      get "/api/v1/customers/find?id=#{customer1.id}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(customer1.id)
      expect(result["id"]).to_not eq(customer2.id)
    end

    it "can find a customer by its first name" do
      customer1 = create(:customer, first_name: "Han")
      customer2 = create(:customer)

      get "/api/v1/customers/find?first_name=Han"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(customer1.id)
      expect(result["id"]).to_not eq(customer2.id)
    end

    it "can find a customer by its last name" do
      customer1 = create(:customer, last_name: "Solo")
      customer2 = create(:customer)

      get "/api/v1/customers/find?last_name=Solo"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(customer1.id)
      expect(result["id"]).to_not eq(customer2.id)
    end

    it "can find a customer by when it was created" do
      created = "2017-01-01T00:00:00.000Z"
      customer1 = create(:customer, created_at: created)
      customer2 = create(:customer)

      get "/api/v1/customers/find?created_at=#{created}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(customer1.id)
      expect(result["id"]).to_not eq(customer2.id)
    end

    it "can find a customer by when it was updated" do
      updated = "2017-02-01T00:00:00.000Z"
      customer1 = create(:customer, updated_at: updated)
      customer2 = create(:customer)

      get "/api/v1/customers/find?updated_at=#{updated}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(customer1.id)
      expect(result["id"]).to_not eq(customer2.id)
    end
  end

  context "find all method" do
    it "can find all customers by id" do
      customer = create(:customer)
      create_list(:customer, 4)

      get "/api/v1/customers/find_all?id=#{customer.id}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(1)

      results.each do |result|
        expect(result["id"]).to eq(customer.id)
      end
    end

    it "can find all customers by their first name" do
      customers = create_list(:customer, 3, first_name: "Han")
      create_list(:customer, 4)

      get "/api/v1/customers/find_all?first_name=Han"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      results.each do |result|
        expect(result["first_name"]).to eq("Han")
      end
    end

    it "can find all customers by their last name" do
      customers = create_list(:customer, 5, last_name: "Solo")
      create_list(:customer, 4)

      get "/api/v1/customers/find_all?last_name=Solo"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(5)

      results.each do |result|
        expect(result["last_name"]).to eq("Solo")
      end
    end

    it "can find all customers by when they were created" do
      created = "2017-01-01T00:00:00.000Z"
      customers = create_list(:customer, 2, created_at: created)
      create_list(:customer, 4)

      get "/api/v1/customers/find_all?created_at=#{created}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(2)

      expect(results.first["id"]).to eq(customers.first.id)
      expect(results.second["id"]).to eq(customers.second.id)
    end

    it "can find all customers by when they were updated" do
      updated = "2017-02-01T00:00:00.000Z"
      customers = create_list(:customer, 3, updated_at: updated)
      create_list(:customer, 2)

      get "/api/v1/customers/find_all?updated_at=#{updated}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      expect(results.first["id"]).to eq(customers.first.id)
      expect(results.second["id"]).to eq(customers.second.id)
      expect(results.third["id"]).to eq(customers.third.id)
    end
  end

  context "relationship methods" do
    it "can find all the transactions for a customer" do
      customer = create(:customer)
      transactions = []
      3.times { transactions << create(:transaction, invoice: create(:invoice, customer: customer))}
      create_list(:transaction, 4)

      get "/api/v1/customers/#{customer.id}/transactions"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      expect(results.first["id"]).to eq(transactions.first.id)
      expect(results.second["id"]).to eq(transactions.second.id)
      expect(results.third["id"]).to eq(transactions.third.id)
    end

    it "can find all the invoices for a customer" do
      customer = create(:customer)
      invoices = create_list(:invoice, 2, customer: customer)
      create_list(:invoice, 3)

      get "/api/v1/customers/#{customer.id}/invoices"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(2)

      expect(results.first["id"]).to eq(invoices.first.id)
      expect(results.second["id"]).to eq(invoices.second.id)
    end
  end

end
