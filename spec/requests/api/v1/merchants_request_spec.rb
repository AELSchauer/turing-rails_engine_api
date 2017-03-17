require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
     create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_success

      merchants = JSON.parse(response.body)

      expect(merchants.count).to eq(3)
   end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_success
    expect(merchant["id"]).to eq(id)
  end

  it "serializes attributes" do
    merchant_1 = Merchant.create(
      name: "amazon",
      created_at: "1234",
      updated_at: "5678"
    )
    expect(merchant_1).to have_attributes(:name => "amazon")
    expect(merchant_1).to_not have_attributes(:updated_at => "1234")
    expect(merchant_1).to_not have_attributes(:created_at => "5678")
  end

  context "find method" do
    it "can find a merchant by its id" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)

      get "/api/v1/merchants/find?id=#{merchant1.id}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(merchant1.id)
      expect(result["id"]).to_not eq(merchant2.id)
    end

    it "can find a merchant by its name" do
      merchant1 = create(:merchant, name: "Nike")
      merchant2 = create(:merchant)

      get "/api/v1/merchants/find?name=Nike"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(merchant1.id)
      expect(result["id"]).to_not eq(merchant2.id)
    end

    it "can find a merchant by when it was created" do
      created = "2017-01-01T00:00:00.000Z"
      merchant1 = create(:merchant, created_at: created)
      merchant2 = create(:merchant)

      get "/api/v1/merchants/find?created_at=#{created}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(merchant1.id)
      expect(result["id"]).to_not eq(merchant2.id)
    end

    it "can find a merchant by when it was updated" do
      updated = "2017-02-01T00:00:00.000Z"
      merchant1 = create(:merchant, updated_at: updated)
      merchant2 = create(:merchant)

      get "/api/v1/merchants/find?updated_at=#{updated}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(merchant1.id)
      expect(result["id"]).to_not eq(merchant2.id)
    end
  end

  context "find all method" do
    it "can find all merchants by id" do
      create_list(:merchant, 3)

      get "/api/v1/merchants/find_all?id=#{Merchant.first.id}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.first["id"]).to eq(Merchant.first.id)
      expect(results.last["id"]).to eq(Merchant.last.id)
      expect(results.count).to eq(3)
    end

    it "can find all merchants by their name" do
      merchants = create_list(:merchant, 3, name: "Nike")
      create_list(:merchant, 4)

      get "/api/v1/merchants/find_all?name=Nike"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      results.each do |result|
        expect(result["name"]).to eq("Nike")
      end
    end

    it "can find all merchants by when they were created" do
      created = "2017-01-01T00:00:00.000Z"
      merchants = create_list(:merchant, 2, created_at: created)
      create_list(:merchant, 4)

      get "/api/v1/merchants/find_all?created_at=#{created}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(2)

      expect(results.first["id"]).to eq(merchants.first.id)
      expect(results.second["id"]).to eq(merchants.second.id)
    end

    it "can find all merchants by when they were updated" do
      updated = "2017-02-01T00:00:00.000Z"
      merchants = create_list(:merchant, 3, updated_at: updated)
      create_list(:merchant, 2)

      get "/api/v1/merchants/find_all?updated_at=#{updated}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      expect(results.first["id"]).to eq(merchants.first.id)
      expect(results.second["id"]).to eq(merchants.second.id)
      expect(results.third["id"]).to eq(merchants.third.id)
    end
  end

  context "random method" do
    it "can find a random merchant" do
      create_list(:merchant, 3)

      get '/api/v1/merchants/random'

      merchant = JSON.parse(response.body)

      expect(response).to be_success
      expect(merchant).to be_a(Hash)
      expect(merchant).to have_key("id")
      expect(merchant).to have_key("name")
    end
  end

  context "relationship methods" do
    it "can find all the items for a merchant" do
      merchant = create(:merchant)
      items = create_list(:item, 2, merchant: merchant)
      create_list(:item, 3)

      get "/api/v1/merchants/#{merchant.id}/items"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(2)

      expect(results.first["id"]).to eq(items.first.id)
      expect(results.second["id"]).to eq(items.second.id)
    end

    it "can find all the invoices for a merchant" do
      merchant = create(:merchant)
      invoices = create_list(:invoice, 2, merchant: merchant)
      create_list(:invoice, 3)

      get "/api/v1/merchants/#{merchant.id}/invoices"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(2)

      expect(results.first["id"]).to eq(invoices.first.id)
      expect(results.second["id"]).to eq(invoices.second.id)
    end
  end

  context "business logic methods" do
    it "can get the revenue for a single merchant" do
      merchant = create(:merchant)
      invoices = create_list(:invoice, 3, merchant: merchant)
      create(:transaction, invoice: invoices.first)
      create(:transaction, invoice: invoices.first, result: "failed")
      create(:transaction, invoice: invoices.second, result: "failed")
      create(:transaction, invoice: invoices.third)
      create(:invoice_item, invoice: invoices.first)
      create(:invoice_item, invoice: invoices.first, quantity: 2)
      create(:invoice_item, invoice: invoices.first, unit_price: "20.00")
      create(:invoice_item, invoice: invoices.first, quantity: 2, unit_price: "20.00")
      create(:invoice_item, invoice: invoices.second)
      create(:invoice_item, invoice: invoices.second, quantity: 2)
      create(:invoice_item, invoice: invoices.second, unit_price: "20.00")
      create(:invoice_item, invoice: invoices.second, quantity: 2, unit_price: "20.00")
      create(:invoice_item, invoice: invoices.third, quantity: 2)
      create(:invoice_item, invoice: invoices.third, unit_price: "20.00")

      get "/api/v1/merchants/#{merchant.id}/revenue"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["revenue"]).to eq("130.0")
    end

    it "can get the total revenue for all merchants" do
      date_1 = "2017-01-01T00:00:00.000Z"
      date_2 = "2017-02-02T00:00:00.000Z"
      create_list(:invoice, 2, created_at: date_1)
      create_list(:invoice, 2, created_at: date_2)
      Invoice.all.each do |invoice|
        create(:invoice_item, invoice: invoice)
        create(:invoice_item, invoice: invoice, quantity: 2, unit_price: "20.00")
      end
      create(:transaction, invoice: Invoice.first, result: "success")
      create(:transaction, invoice: Invoice.second, result: "success")
      create(:transaction, invoice: Invoice.third, result: "success")
      create(:transaction, invoice: Invoice.fourth, result: "failed")

      get "/api/v1/merchants/revenue?date=#{date_1}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["total_revenue"]).to eq("100.0")
    end
  end
end
