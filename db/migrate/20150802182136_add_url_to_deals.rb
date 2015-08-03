class AddUrlToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :url, :string
  end
end
