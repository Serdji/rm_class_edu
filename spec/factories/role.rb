FactoryGirl.define do
  factory :role do
    name { Faker::Lorem.word }
    credentials { YAML.load_file(Rails.root.join('config', 'credentials.yml'))['superuser'] }

    factory :editor_role do
      credentials { YAML.load_file(Rails.root.join('config', 'credentials.yml'))['editor'] }
    end
  end
end
