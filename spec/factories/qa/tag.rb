FactoryGirl.define do
  factory :qa_tag, class: Qa::Tag do
    sequence(:name) { |number| "#{Faker::Lorem.sentence} #{rand(10000)} #{number}" }
    weight { rand(1..100) }
    is_published true
  end
end
