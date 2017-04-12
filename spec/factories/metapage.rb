FactoryGirl.define do
  factory :metapage do
    title       { Faker::Lorem.word }
    label       { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    metapages_type
  end
end
