class RoundsController < ApplicationController
  before_action :set_game, only: [:new, :show, :calculate_result]
  before_action :set_round, only: [:show, :calculate_result]

  def new
    #create a new game round
    game_current_round = @game.current_round
    # a new game round cannot be created unless no game rounds exists or the current game round had a result (win or draw)
    if game_current_round.nil? || (!game_current_round.nil? && !game_current_round.result.nil?)
      @round = Round.new
      @round.game = @game
      @round.current_player = @game.first_player
      @round.save
    end
    #show the game grid
    redirect_to @game
  end

  def calculate_result
    #determine if there is a winner / draw or continue to play
    require 'matrix'
    # game is_draw unless a cell is empty
    is_draw = true
    current_player_wins = false
    player_symbol = @game.current_round.current_player == @game.first_player ? "X" : "O"

    #dummy vector holding the winning combination of three entries of the current player symbol
    winning_combination = Matrix.build(1,3){player_symbol}.row(0)

    #build the grid matrix from the html hidden fields mapped to grid html table cells
    grid = Matrix.build(3, 3) do |row_index, column_index|
      cell_value = params["cell_#{row_index}_#{column_index}"]
      if cell_value.blank?
        is_draw = false
      end
      cell_value
    end

    #check if a row equals the winning combination
    current_player_wins = grid.row_vectors.any? { |r| r == winning_combination }
    #check if a column equals the winning combination
    unless current_player_wins
      current_player_wins = grid.column_vectors.any? { |c| c == winning_combination }
    end
    #check if main diagonal equals the winning combination
    unless current_player_wins
      current_player_wins = Vector[*grid.each(:diagonal).to_a] == winning_combination
    end
    #check if secondary diagonal equals the winning combination
    unless current_player_wins
      current_player_wins = (0...3).all? { |i| grid.to_a[i][3-i-1] == player_symbol }
    end

    if is_draw
      #game is a draw - update draws count for each player and pass a result message
      @round.result = "draw"
      @round.save
      @game.first_player.draws_count += 1
      @game.first_player.save
      @game.second_player.draws_count +=1
      @game.second_player.save

      @result = t("games.draw")

    elsif current_player_wins
      #game is a win - update wins_count and losses_count for each player and pass a result message
      @round.result = "win"
      @round.winner = @round.current_player
      @round.save

      winner_player = @round.current_player
      winner_player.wins_count += 1
      winner_player.save

      losing_player = @game.first_player == @round.current_player ? @game.second_player : @game.first_player
      losing_player.loses_count +=1
      losing_player.save

      @result = t("games.player_win",:player_name => winner_player.name)
    else
      #game will continue just change the current player in the round object
      @current_player = @game.first_player == @round.current_player ? @game.second_player : @game.first_player
      @round.current_player =@current_player
      @round.save
      @current_player_symbol = @game.current_round.current_player == @game.first_player ? "X" : "O"
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:game_id])
    end

    def set_round
      @round = Round.find(params[:id])
    end
end
