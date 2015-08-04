class AddAddressToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :address, :string
  end
end
