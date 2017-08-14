FactoryGirl.define do
  factory :qa_user, class: Qa::User do
    first_name  { Faker::Name.name }
    last_name { Faker::Name.name }

    external_id { SecureRandom.hex }
    external_id_type 'rsid'
  end
end
