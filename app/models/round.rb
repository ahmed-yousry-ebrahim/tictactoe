class Round < ActiveRecord::Base
  belongs_to :game, :counter_cache => true
  belongs_to :current_player, :class_name => 'Player', :foreign_key => :current_player_id
  belongs_to :winner, :class_name => 'Player', :foreign_key => :winner_id
end
