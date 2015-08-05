class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :author_name
      t.text :body
      t.references :deal, index: true, foreign_key: true
      t.references :consumer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
