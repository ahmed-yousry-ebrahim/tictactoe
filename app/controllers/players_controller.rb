class PlayersController < ApplicationController

  # GET /players
  def index
    @players = Player.order(wins_count: :desc).order(draws_count: :desc)
  end

end
