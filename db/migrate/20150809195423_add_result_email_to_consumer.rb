class AddResultEmailToConsumer < ActiveRecord::Migration
  def change
    add_column :consumers, :result_email, :boolean
  end
end
