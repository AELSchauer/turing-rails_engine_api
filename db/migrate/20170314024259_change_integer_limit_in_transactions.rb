class ChangeIntegerLimitInTransactions < ActiveRecord::Migration[5.0]
  def change
    change_column :transactions, :credit_card_number, :string
  end
end
