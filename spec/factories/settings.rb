FactoryGirl.define do
  factory :settings do
    var { Faker::Lorem.word }
    value { Faker::Lorem.word }
  end
end
