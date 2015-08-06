class AddTotalPointsToConsumer < ActiveRecord::Migration
  def change
    add_column :consumers, :total_points, :integer
  end
end
