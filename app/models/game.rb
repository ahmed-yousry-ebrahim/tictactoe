class Game < ActiveRecord::Base
  belongs_to :first_player, :class_name => 'Player', :foreign_key => "first_player_id", autosave: true
  belongs_to :second_player, :class_name => 'Player', :foreign_key => "second_player_id", autosave: true
  has_many :rounds
  validates_presence_of :first_player, :second_player

  def current_round
    self.rounds.last
  end
end
