require 'rails_helper'

describe "InvoiceItems API" do
  it "sends a list of invoice_items" do
     create_list(:invoice_item, 3)

      get '/api/v1/invoice_items'

      expect(response).to be_success

      invoice_items = JSON.parse(response.body)
   end

   it "can get one invoice_item by its id" do
    id = create(:invoice_item).id

    get "/api/v1/invoice_items/#{id}"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_item["id"]).to eq(id)
  end

  it "serializes attributes" do
    invoice_item_1 = InvoiceItem.create(quantity: 5, unit_price: 3.99, created_at: "1234", updated_at: "5678")
    expect(invoice_item_1).to have_attributes(:quantity => 5)
    expect(invoice_item_1).to have_attributes(:unit_price => 3.99)
    expect(invoice_item_1).to_not have_attributes(:updated_at => "1234")
    expect(invoice_item_1).to_not have_attributes(:created_at => "5678")
  end

end
