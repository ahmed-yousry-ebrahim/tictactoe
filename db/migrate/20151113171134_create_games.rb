class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :first_player_id
      t.integer :second_player_id
      t.integer :rounds_count

      t.timestamps
    end
  end
end
