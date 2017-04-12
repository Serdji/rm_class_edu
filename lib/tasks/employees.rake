namespace :employees do
  namespace :passwords do
    desc 'Update passwords for standart employees (superuser, chief_editor, editor)'
    task update: :environment do
      {
        'superuser@class.rambler.ru' => ENV['SUPERUSER_PASSWORD'],
        'chief_editor@class.rambler.ru' => ENV['CHIEF_EDITOR_PASSWORD'],
        'editor@class.rambler.ru' => ENV['EDITOR_PASSWORD']
      }.each do |email, password|
        e = Employee.find_by(email: email)
        e.password = password
        e.save
      end
    end
  end

  namespace :credentials do
    desc 'Reset credentials for roles (superuser, chief_editor, editor)'
    task update: :environment do
      puts 'Loading roles'
      credentials = YAML.load_file(Rails.root.join('config', 'credentials.yml'))

      [
        { name: 'superuser', credentials: credentials['superuser'] },
        { name: 'chief_editor', credentials: credentials['chief_editor'] },
        { name: 'editor', credentials: credentials['editor'] }
      ].each do |attrs|
        role = Role.find_or_create_by(name: attrs[:name])
        role.credentials = attrs[:credentials]
        role.save
      end
    end
  end
end
