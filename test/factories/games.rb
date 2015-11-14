FactoryGirl.define do
  factory :game do
    association :first_player, :factory => :player
    association :second_player, :factory => :player
  end

end
