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
end
