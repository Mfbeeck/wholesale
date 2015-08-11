class AddRemainingParticipantsToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :remaining_participants, :integer
  end
end
