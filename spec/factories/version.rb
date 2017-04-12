FactoryGirl.define do
  factory :version do
    association :item, factory: :employee
    event { 'update' }
    employee
    object { Faker::Lorem.paragraph }
  end
end
