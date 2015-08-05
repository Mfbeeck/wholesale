class AddWinningConsumerToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :winning_consumer, :string
  end
end
