require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
     create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_success

      merchants = JSON.parse(response.body)
   end

   it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_success
    expect(merchant["id"]).to eq(id)
  end

  it "serializes attributes" do
    merchant_1 = Merchant.create(name: "amazon", created_at: "1234", updated_at: "5678")
    expect(merchant_1).to have_attributes(:name => "amazon")
    expect(merchant_1).to_not have_attributes(:updated_at => "1234")
    expect(merchant_1).to_not have_attributes(:created_at => "5678")
  end

  context "business logic methods" do
    it "can get the revenue for a single merchant" do
      merchant = create(:merchant)
      create_list(:invoice_item, 3, invoice: create(:invoice, merchant: merchant))
      create_list(:invoice_item, 2, invoice: create(:invoice, merchant: merchant))

      get "/api/v1/merchants/#{merchant.id}/revenue"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(id)
      expect(result["revenue"]).to eq(50)
    end
  end
end
