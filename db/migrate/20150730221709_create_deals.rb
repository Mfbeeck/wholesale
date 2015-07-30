class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :name
      t.string :description
      t.float :price
      t.string :image
      t.integer :threshold
      t.string :start_date
      t.string :end_date
      t.string :status
      t.belongs_to :supplier, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
