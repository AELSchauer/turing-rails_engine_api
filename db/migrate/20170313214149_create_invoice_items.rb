class CreateInvoiceItems < ActiveRecord::Migration[5.0]
  def change
    create_table :invoice_items do |t|
      t.integer :quantity
      t.decimal :unit_price, precision: 5, scale: 2
      t.references :item, foreign_key: true
      t.references :invoice, foreign_key: true

      t.timestamps null: false
    end
  end
end
