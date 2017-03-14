require 'rails_helper'

describe "Invoices API" do
  it "sends a list of invoices" do
     create_list(:invoice, 3)

      get '/api/v1/invoices'

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
end
