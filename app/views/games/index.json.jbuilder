json.array!(@games) do |game|
  json.extract! game, :id, :rounds_count
  json.url game_url(game, format: :json)
end
