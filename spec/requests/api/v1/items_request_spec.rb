require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
     create_list(:item, 3)

      get '/api/v1/items'

      expect(response).to be_success

      items = JSON.parse(response.body)
   end

   it "can get one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(item["id"]).to eq(id)
  end

  it "serializes attributes" do
    item_1 = Item.create(name: "kurig", description: "make brewing coffee easier", unit_price: 58.99, merchant_id: 7, created_at: "1234", updated_at: "5678")
    expect(item_1).to have_attributes(:name => "kurig")
    expect(item_1).to have_attributes(:description => "make brewing coffee easier")
    expect(item_1).to have_attributes(:unit_price => 58.99)
    expect(item_1).to have_attributes(:merchant_id => 7)
    expect(item_1).to_not have_attributes(:updated_at => "1234")
    expect(item_1).to_not have_attributes(:created_at => "5678")
  end
end
