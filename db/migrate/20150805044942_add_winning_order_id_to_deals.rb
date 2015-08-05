class AddWinningOrderIdToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :winning_order_id, :integer
  end
end
