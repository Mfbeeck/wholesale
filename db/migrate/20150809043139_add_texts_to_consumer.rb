class AddTextsToConsumer < ActiveRecord::Migration
  def change
    add_column :consumers, :texts, :boolean
  end
end
