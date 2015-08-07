class AddWinnersShippingAddressToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :winners_shipping_address, :string
  end
end
