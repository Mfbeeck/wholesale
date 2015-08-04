class AddProductTypeToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :product_type, :string
  end
end
