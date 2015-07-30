class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :email
      t.string :password_digest

      t.timestamps null: false
    end
    add_index :suppliers, :username, unique: true
  end
end
