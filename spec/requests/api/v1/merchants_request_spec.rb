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
end
