FactoryGirl.define do
  factory :metapages_type do
    name       { Faker::Lorem.word }
    url        { Faker::Lorem.word }
  end
end
