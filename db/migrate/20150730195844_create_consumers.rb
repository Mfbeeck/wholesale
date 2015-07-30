class CreateConsumers < ActiveRecord::Migration
  def change
    create_table :consumers do |t|
	  t.string :username
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :email
      t.string :password_digest
      t.timestamps null: false
    end
  end
end
