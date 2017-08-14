FactoryGirl.define do
  factory :employee, aliases: [:rolable] do
    email              { Faker::Internet.email('dev') }
    first_name         { Faker::Name.name }
    last_name          { Faker::Name.name }
    password           { Faker::Internet.password }
    encrypted_password { Employee.new(password: password).encrypted_password }
    role

    factory :editor do
      after(:create) do |employee, _evaluator|
        employee.role = create(:editor_role)
        employee.save
      end
    end
  end
end
