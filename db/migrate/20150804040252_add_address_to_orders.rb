class AddAddressToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :Address, :string
  end
end
