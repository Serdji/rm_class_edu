namespace 'db:seed' do
  desc 'Load employees seed'
  task employees: :roles do
    puts 'Loading employees'

    attributes = {
      email:                 'superuser@class.rambler.ru',
      password:              ENV['SUPERUSER_PASSWORD'],
      password_confirmation: ENV['SUPERUSER_PASSWORD'],
      first_name:            'Суперюзер',
      last_name:             'Rambler DS'
    }
    employee = Employee.create(attributes)
    employee.roles << Role.find_by(name: 'superuser')

    attributes = {
      email:                 'chief_editor@class.rambler.ru',
      password:              ENV['CHIEF_EDITOR_PASSWORD'],
      password_confirmation: ENV['CHIEF_EDITOR_PASSWORD'],
      first_name:            'Главный редактор',
      last_name:             'Rambler DS'
    }
    employee = Employee.create(attributes)
    employee.roles << Role.find_by(name: 'chief_editor')

    attributes = {
      email:                 'editor@class.rambler.ru',
      password:              ENV['EDITOR_PASSWORD'],
      password_confirmation: ENV['EDITOR_PASSWORD'],
      first_name:            'Редактор',
      last_name:             'Rambler DS'
    }
    employee = Employee.create(attributes)
    employee.roles << Role.find_by(name: 'editor')
  end
end
