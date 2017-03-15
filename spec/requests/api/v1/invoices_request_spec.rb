require 'rails_helper'

describe "Invoices API" do
  it "sends a list of invoices" do
     create_list(:invoice, 3)

      get "/api/v1/invoices"

      expect(response).to be_success

      invoices = JSON.parse(response.body)
   end

   it "can get one invoice by its id" do
    id = create(:invoice).id

    get "/api/v1/invoices/#{id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice["id"]).to eq(id)
  end

  it "serializes attributes" do
    invoice_1 = Invoice.create(customer_id: 83, merchant_id: 56, created_at: "1234", updated_at: "5678")
    expect(invoice_1).to have_attributes(:customer_id => 83)
    expect(invoice_1).to have_attributes(:merchant_id => 56)
    expect(invoice_1).to_not have_attributes(:updated_at => "1234")
    expect(invoice_1).to_not have_attributes(:created_at => "5678")
  end

  context "find method" do
    it "can find an invoice by its id" do
      invoice1 = create(:invoice)
      invoice2 = create(:invoice)

      get "/api/v1/invoices/find?id=#{invoice1.id}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(invoice1.id)
      expect(result["id"]).to_not eq(invoice2.id)
    end

    it "can find an invoice by its customer id" do
      customer1 = create(:customer)
      customer2 = create(:customer)
      invoice1 = create(:invoice, customer: customer1)
      invoice2 = create(:invoice, customer: customer2)

      get "/api/v1/invoices/find?customer_id=#{customer1.id}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(invoice1.id)
      expect(result["id"]).to_not eq(invoice2.id)
    end

    it "can find an invoice by its merchant id" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      invoice1 = create(:invoice, merchant: merchant1)
      invoice2 = create(:invoice, merchant: merchant2)

      get "/api/v1/invoices/find?merchant_id=#{merchant1.id}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(invoice1.id)
      expect(result["id"]).to_not eq(invoice2.id)
    end

    it "can find an invoice by its status" do
      invoice1 = create(:invoice, status: "cancelled")
      invoice2 = create(:invoice)

      get "/api/v1/invoices/find?status=cancelled"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(invoice1.id)
      expect(result["id"]).to_not eq(invoice2.id)
    end

    it "can find an invoice by when it was created" do
      created = "2017-01-01T00:00:00.000Z"
      invoice1 = create(:invoice, created_at: created)
      invoice2 = create(:invoice)

      get "/api/v1/invoices/find?created_at=#{created}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(invoice1.id)
      expect(result["id"]).to_not eq(invoice2.id)
    end

    it "can find an invoice by when it was updated" do
      updated = "2018-02-01T00:00:00.000Z"
      invoice1 = create(:invoice, updated_at: updated)
      invoice2 = create(:invoice)

      get "/api/v1/invoices/find?updated_at=#{updated}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(invoice1.id)
      expect(result["id"]).to_not eq(invoice2.id)
    end
  end

  context "find all method" do
    it "can find all invoices by id" do
      invoice = create(:invoice)
      create_list(:invoice, 4)

      get "/api/v1/invoices/find_all?id=#{invoice.id}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(1)

      results.each do |result|
        expect(result["id"]).to eq(invoice.id)
      end
    end

    it "can find all invoices by their customer id" do
      customer = create(:customer)
      invoices = create_list(:invoice, 3, customer: customer)
      create_list(:invoice, 4)

      get "/api/v1/invoices/find_all?customer_id=#{customer.id}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      results.each do |result|
        expect(result["customer_id"]).to eq(customer.id)
      end
    end

    it "can find all invoices by their merchant id" do
      merchant = create(:merchant)
      invoices = create_list(:invoice, 5, merchant: merchant)
      create_list(:invoice, 4)

      get "/api/v1/invoices/find_all?merchant_id=#{merchant.id}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(5)

      results.each do |result|
        expect(result["merchant_id"]).to eq(merchant.id)
      end
    end

    it "can find all invoices by when they were created" do
      created = "2017-01-01T00:00:00.000Z"
      invoices = create_list(:invoice, 2, created_at: created)
      create_list(:invoice, 4)

      get "/api/v1/invoices/find_all?created_at=#{created}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(2)

      expect(results.first["id"]).to eq(invoices.first.id)
      expect(results.second["id"]).to eq(invoices.second.id)
    end

    it "can find all invoices by when they were updated" do
      updated = "2017-02-01T00:00:00.000Z"
      invoices = create_list(:invoice, 3, updated_at: updated)
      create_list(:invoice, 2)

      get "/api/v1/invoices/find_all?updated_at=#{updated}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      expect(results.first["id"]).to eq(invoices.first.id)
      expect(results.second["id"]).to eq(invoices.second.id)
      expect(results.third["id"]).to eq(invoices.third.id)
    end
  end
end
