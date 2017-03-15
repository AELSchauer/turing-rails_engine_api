require 'rails_helper'

RSpec.describe "InvoiceItems relationship endpoints", type: :request do
	describe "get /api/v1/invoice_items/:id/invoice" do
		it "returns the invoice for an invoiceitem" do
			invoice = create(:invoice)
			invoice_item = create(:invoice_item, invoice_id: invoice.id)

			get "/api/v1/invoice_items/#{invoice_item.id}/invoice"

			invoice = JSON.parse(response.body)

			expect(response).to be_success
			expect(invoice_item['invoice_id']).to eq(invoice['id'])
		end
	end

	describe "get /api/v1/invoice_items/:id/item" do
		it "returns the item for an invoiceitem" do
			item = create(:item)
			invoice_item = create(:invoice_item, item_id: item.id)

			get "/api/v1/invoice_items/#{invoice_item.id}/item"

			item = JSON.parse(response.body)

			expect(response).to be_success
			expect(invoice_item['item_id']).to eq(item['id'])
		end
	end
end
