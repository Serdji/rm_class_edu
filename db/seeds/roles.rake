namespace 'db:seed' do
  desc 'Load roles seed'
  task 'roles' do
    puts 'Loading roles'
    credentials = YAML.load_file(Rails.root.join('config', 'credentials.yml'))

    [
      { name: 'superuser', credentials: credentials['superuser'] },
      { name: 'chief_editor', credentials: credentials['chief_editor'] },
      { name: 'editor', credentials: credentials['editor'] }
    ].each do |attrs|
      Role.find_or_create_by(name: attrs[:name]) { |r| r.credentials = attrs[:credentials] }
    end
  end
end
