class AddThresholdReachedToDeal < ActiveRecord::Migration
  def change
    add_column :deals, :threshold_reached, :boolean
  end
end
