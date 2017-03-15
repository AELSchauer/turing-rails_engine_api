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
      customer = create(:customer)
      invoice1 = create(:invoice, customer: customer)
      invoice2 = create(:invoice, customer: customer)
      invoice3 = create(:invoice)

      get "/api/v1/invoices/find?customer_id=#{customer.id}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(invoice1.id)
      expect(result["id"]).to_not eq(invoice2.id)
      expect(result["id"]).to_not eq(invoice3.id)
    end

    it "can find an invoice by its merchant id" do
      merchant = create(:merchant)
      invoice1 = create(:invoice, merchant: merchant)
      invoice2 = create(:invoice, merchant: merchant)
      invoice3 = create(:invoice)

      get "/api/v1/invoices/find?merchant_id=#{merchant.id}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(invoice1.id)
      expect(result["id"]).to_not eq(invoice2.id)
      expect(result["id"]).to_not eq(invoice3.id)
    end

    it "can find an invoice by its status" do
      invoice1 = create(:invoice, status: "cancelled")
      invoice2 = create(:invoice, status: "cancelled")
      invoice3 = create(:invoice)

      get "/api/v1/invoices/find?status=cancelled"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(invoice1.id)
      expect(result["id"]).to_not eq(invoice2.id)
      expect(result["id"]).to_not eq(invoice3.id)
    end

    it "can find an invoice by when it was created" do
      created = "2017-01-01T00:00:00.000Z"
      updated = "2017-02-01T00:00:00.000Z"
      invoice1 = create(:invoice, created_at: created)
      invoice2 = create(:invoice, created_at: created)
      invoice3 = create(:invoice)

      get "/api/v1/invoices/find?status=cancelled"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(invoice1.id)
      expect(result["id"]).to_not eq(invoice2.id)
      expect(result["id"]).to_not eq(invoice3.id)
    end
  end
end
