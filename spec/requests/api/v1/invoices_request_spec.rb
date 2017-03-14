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
  end
end
