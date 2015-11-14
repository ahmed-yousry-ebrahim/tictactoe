FactoryGirl.define do
  factory :player do |f|
    f.sequence(:name) { |n| "player #{n}" }
  end

end
