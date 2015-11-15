class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]


  # GET /games/1
  # GET /games/1.json
  def show
    #show the game grid
    #determine the current player symbol given the fact that first player will always get (X) symbol
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
    #create the first player
    first_player = Player.new
    first_player.name = params[:first_player_name]
    first_player.game = @game

    #create the second player
    second_player = Player.new
    second_player.name = params[:second_player_name]
    second_player.game = @game

    # add first and second players to the game object
    @game.first_player = first_player
    @game.second_player = second_player

    respond_to do |format|
      if @game.save
        #create a new game round using a redirect to new_game_round_path
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
