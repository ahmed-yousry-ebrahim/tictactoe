json.array!(@rounds) do |round|
  json.extract! round, :id, :game_id, :result, :winner_id
  json.url round_url(round, format: :json)
end
