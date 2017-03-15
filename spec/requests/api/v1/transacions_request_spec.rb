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
    created = "2017-01-01T00:00:00.000Z"
    updated = "2017-02-01T00:00:00.000Z"
    transaction_1 = Transaction.create(
      credit_card_number: "123456",
      result: "accepted",
      invoice_id: 3,
      created_at: created,
      updated_at: updated
    )
    expect(transaction_1).to have_attributes(credit_card_number: "123456")
    expect(transaction_1).to have_attributes(result: "accepted")
    expect(transaction_1).to have_attributes(invoice_id: 3)
    expect(transaction_1).to_not have_attributes(created_at: created)
    expect(transaction_1).to_not have_attributes(updated_at: updated)
  end

  context "find method" do
    it "can find a transaction by its id" do
      transaction1 = create(:transaction)
      transaction2 = create(:transaction)

      get "/api/v1/transactions/find?id=#{transaction1.id}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(transaction1.id)
      expect(result["id"]).to_not eq(transaction2.id)
    end

    it "can find a transaction by its credit card number" do
      transaction1 = create(:transaction, credit_card_number: "98765")
      transaction2 = create(:transaction)

      get "/api/v1/transactions/find?credit_card_number=98765"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(transaction1.id)
      expect(result["id"]).to_not eq(transaction2.id)
    end

    it "can find a transaction by its result" do
      transaction1 = create(:transaction, result: "accepted")
      transaction2 = create(:transaction)

      get "/api/v1/transactions/find?result=accepted"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(transaction1.id)
      expect(result["id"]).to_not eq(transaction2.id)
    end

    it "can find a transaction by its invoice id" do
      invoice1 = create(:invoice)
      invoice2 = create(:invoice)
      transaction1 = create(:transaction, invoice: invoice1)
      transaction2 = create(:transaction, invoice: invoice2)

      get "/api/v1/transactions/find?invoice_id=#{invoice1.id}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(transaction1.id)
      expect(result["id"]).to_not eq(transaction2.id)
    end

    it "can find a transaction by when it was created" do
      created = "2017-01-01T00:00:00.000Z"
      transaction1 = create(:transaction, created_at: created)
      transaction2 = create(:transaction)

      get "/api/v1/transactions/find?created_at=#{created}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(transaction1.id)
      expect(result["id"]).to_not eq(transaction2.id)
    end

    it "can find a transaction by when it was updated" do
      updated = "2017-02-01T00:00:00.000Z"
      transaction1 = create(:transaction, updated_at: updated)
      transaction2 = create(:transaction)

      get "/api/v1/transactions/find?updated_at=#{updated}"

      result = JSON.parse(response.body)

      expect(response).to be_success
      expect(result["id"]).to eq(transaction1.id)
      expect(result["id"]).to_not eq(transaction2.id)
    end
  end

  context "find all method" do
    it "can find all transactions by id" do
      transaction = create(:transaction)
      create_list(:transaction, 4)

      get "/api/v1/transactions/find_all?id=#{transaction.id}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(1)

      results.each do |result|
        expect(result["id"]).to eq(transaction.id)
      end
    end

    it "can find all transactions by their credit card number" do
      transactions = create_list(:transaction, 3, credit_card_number: "123456")
      create_list(:transaction, 4)

      get "/api/v1/transactions/find_all?credit_card_number=123456"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      results.each do |result|
        expect(result["credit_card_number"]).to eq("123456")
      end
    end

    it "can find all transactions by their result" do
      transactions = create_list(:transaction, 5, result: "accepted")
      create_list(:transaction, 4)

      get "/api/v1/transactions/find_all?result=accepted"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(5)

      results.each do |result|
        expect(result["result"]).to eq("accepted")
      end
    end

    it "can find all transactions by their invoice id" do
      invoice = create(:invoice)
      transactions = create_list(:transaction, 3, invoice: invoice)
      create_list(:transaction, 4)

      get "/api/v1/transactions/find_all?invoice_id=#{invoice.id}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      results.each do |result|
        expect(result["invoice_id"]).to eq(invoice.id)
      end
    end

    it "can find all transactions by when they were created" do
      created = "2017-01-01T00:00:00.000Z"
      transactions = create_list(:transaction, 2, created_at: created)
      create_list(:transaction, 4)

      get "/api/v1/transactions/find_all?created_at=#{created}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(2)

      expect(results.first["id"]).to eq(transactions.first.id)
      expect(results.second["id"]).to eq(transactions.second.id)
    end

    it "can find all transactions by when they were updated" do
      updated = "2017-02-01T00:00:00.000Z"
      transactions = create_list(:transaction, 3, updated_at: updated)
      create_list(:transaction, 2)

      get "/api/v1/transactions/find_all?updated_at=#{updated}"

      results = JSON.parse(response.body)

      expect(response).to be_success
      expect(results.count).to eq(3)

      expect(results.first["id"]).to eq(transactions.first.id)
      expect(results.second["id"]).to eq(transactions.second.id)
      expect(results.third["id"]).to eq(transactions.third.id)
    end
  end

  context "relationship methods" do
    it "can returns the invoice for a transaction" do
      invoice = create(:invoice)
			transaction = create(:transaction, invoice_id: invoice.id)

			get "/api/v1/transactions/#{transaction.id}/invoice"

			invoice = JSON.parse(response.body)

			expect(response).to be_success
			expect(transaction['invoice_id']).to eq(invoice['id'])
    end
  end

end
