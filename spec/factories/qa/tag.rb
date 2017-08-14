FactoryGirl.define do
  factory :qa_tag, class: Qa::Tag do
    sequence(:name) { |number| "tag##{number}" }
    weight { rand(1..100) }
    is_published true
  end
end
