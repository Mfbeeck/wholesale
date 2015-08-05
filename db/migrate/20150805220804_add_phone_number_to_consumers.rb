class AddPhoneNumberToConsumers < ActiveRecord::Migration
  def change
    add_column :consumers, :phone_number, :string
  end
end
