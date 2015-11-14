json.array!(@players) do |player|
  json.extract! player, :id, :name, :wins_count, :loses_count, :draws_count, :game_id
  json.url player_url(player, format: :json)
end
