class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :game_id
      t.integer :current_player_id
      t.string :result
      t.integer :winner_id

      t.timestamps
    end
  end
end
