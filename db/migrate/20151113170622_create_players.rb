class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :wins_count, :default => 0
      t.integer :loses_count, :default => 0
      t.integer :draws_count, :default => 0
      t.integer :game_id

      t.timestamps
    end
  end
end
