require 'rails_helper'

describe "Transactions API" do
  it "sends a list of transactions" do
     create_list(:transaction, 3)

      get '/api/v1/transactions'

      expect(response).to be_success

      transactions = JSON.parse(response.body)

      expect(transactions.count).to eq(3)
   end

   it "can get one transaction by its id" do
    id = create(:transaction).id

    get "/api/v1/transactions/#{id}"

    transaction = JSON.parse(response.body)

    expect(response).to be_success
    expect(transaction["id"]).to eq(id)
  end

  it "serializes attributes" do
    transaction_1 = Transaction.create(invoice_id: 6, credit_card_number: "8675309", result: "accepted", created_at: "1234", updated_at: "5678")
    expect(transaction_1).to have_attributes(:invoice_id => 6)
    expect(transaction_1).to have_attributes(:credit_card_number => "8675309")
    expect(transaction_1).to have_attributes(:result => "accepted")
    expect(transaction_1).to_not have_attributes(:updated_at => "1234")
    expect(transaction_1).to_not have_attributes(:created_at => "5678")
  end
end
