class AddCreatorIdToRooms < ActiveRecord::Migration[8.0]
  def change
    add_column :rooms, :creator_id, :integer
  end
end
