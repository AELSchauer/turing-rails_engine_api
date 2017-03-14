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
      customer2 = create(:customer, first_name: "Han")

      get "/api/v1/customers/find?first_name=Han"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(customer1.id)
      expect(result["id"]).to_not eq(customer2.id)
    end

    it "can find a customer by its last name" do
      customer1 = create(:customer, last_name: "Solo")
      customer2 = create(:customer, last_name: "Solo")

      get "/api/v1/customers/find?last_name=Solo"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(customer1.id)
      expect(result["id"]).to_not eq(customer2.id)
    end

    it "can find a customer by when it was created" do
      datetime = "2017-01-01T00:00:00.000Z"
      customer1 = Customer.create(
        first_name: "Luke",
        last_name: "Skywalker",
        created_at: datetime,
        updated_at: datetime
      )
      customer2 = Customer.create(
        first_name: "Leia",
        last_name: "Organa",
        created_at: datetime,
        updated_at: datetime
      )

      get "/api/v1/customers/find?created_at=#{datetime}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(customer1.id)
      expect(result["id"]).to_not eq(customer2.id)
    end

    it "can find a customer by when it was updated" do
      datetime = "2017-01-01T00:00:00.000Z"
      customer1 = Customer.create(
        first_name: "Luke",
        last_name: "Skywalker",
        created_at: datetime,
        updated_at: datetime
      )
      customer2 = Customer.create(
        first_name: "Leia",
        last_name: "Organa",
        created_at: datetime,
        updated_at: datetime
      )

      get "/api/v1/customers/find?updated_at=#{datetime}"

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

    it "can find all customers by when they were created" do ||
      datetime = "2017-01-01T00:00:00.000Z"
      customer1 = Customer.create(
        first_name: "Luke",
        last_name: "Skywalker",
        created_at: datetime,
        updated_at: datetime
      )
      customer2 = Customer.create(
        first_name: "Leia",
        last_name: "Organa",
        created_at: datetime,
        updated_at: datetime
      )
      create_list(:customer, 4)


      get "/api/v1/customers/find_all?created_at=#{datetime}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(2)

      results.each do |result|
        expect(result["created_at"]).to eq(datetime)
      end
    end
  end
end
