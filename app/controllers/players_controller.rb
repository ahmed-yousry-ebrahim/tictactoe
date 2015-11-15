class PlayersController < ApplicationController

  # GET /players
  def index
    #get all the players ordered by wins_count descending and draws count also descending
    @players = Player.order(wins_count: :desc).order(draws_count: :desc)
  end

end
