class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]


  # GET /games/1
  # GET /games/1.json
  def show
    @current_player_symbol = @game.current_round.current_player == @game.first_player ? "X" : "O"
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new
    first_player = Player.new
    first_player.name = params[:first_player_name]
    first_player.game = @game

    second_player = Player.new
    second_player.name = params[:second_player_name]
    second_player.game = @game

    @game.first_player = first_player
    @game.second_player = second_player

    respond_to do |format|
      if @game.save
        format.html { redirect_to new_game_round_path(@game), notice: t("games.successfully_created") }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:rounds_count)
    end
end
