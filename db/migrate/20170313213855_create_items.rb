class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.decimal :unit_price, precision: 5, scale: 2
      t.references :merchant, foreign_key: true

      t.timestamps null: false
    end
  end
end
