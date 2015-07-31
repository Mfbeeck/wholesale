class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :deal, index: true, foreign_key: true
      t.references :consumer, index: true, foreign_key: true
      t.string :token
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
