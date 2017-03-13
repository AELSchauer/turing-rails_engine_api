class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :credit_card_number
      t.date :credit_card_expiration_date
      t.string :result
      t.references :invoice, foreign_key: true

      t.timestamps null: false
    end
  end
end
