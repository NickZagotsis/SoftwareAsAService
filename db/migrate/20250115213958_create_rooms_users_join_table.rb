class CreateRoomsUsersJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :rooms, :users do |t|
      # Προσθέτουμε indexes για γρηγορότερες αναζητήσεις
      t.index :room_id
      t.index :user_id
    end
  end
end
