FactoryGirl.define do
  factory :seo do
    title       Faker::Lorem.sentence
    description Faker::Lorem.sentence
    keywords    Faker::Lorem.sentence
  end
end
