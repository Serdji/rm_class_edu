FactoryGirl.define do
  factory :employee, aliases: [:rolable] do
    email              { Faker::Internet.email('dev') }
    first_name         { Faker::Name.name }
    last_name          { Faker::Name.name }
    password           { Faker::Internet.password }
    encrypted_password { Employee.new(password: password).encrypted_password }

    after(:create) do |employee, _evaluator|
      employee.roles = [create(:role)]
    end

    factory :editor do
      after(:create) do |employee, _evaluator|
        employee.roles = [create(:editor_role)]
      end
    end
  end
end
