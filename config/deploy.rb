lock '3.8.1'
set :application, 'class_rambler_ru'
set :rails_env, fetch(:stage)

set :deploy_to, '/var/www/class.rambler.ru'
set :repo_url, 'git@gitlab.rambler.ru:education/education.git'

set :npm_roles, [:front]
set :npm_flags, '--silent --no-progress'

set(:branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call)
set(:branch, ENV['BRANCH']) if ENV['BRANCH']

# Roles on which run rake db:migrate
set :migration_role, 'backend'
set :conditionally_migrate, true

# Defaults to the primary :db server
set :migration_servers, -> { primary(fetch(:migration_role)) }

set :assets_roles, [:backend]

set :keep_assets, 2
set :keep_releases, 10

set :bundle_jobs, 4
set :bundle_bins, fetch(:bundle_bins, []) + %w(eye)

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_dirs, %w(
  log tmp/pids tmp/sockets public/assets
  public/uploads vendor/bundle node_modules
)
set :linked_files, %w(.env.local)

set :rvm_type, :user
set :rvm_roles, [:front, :backend, :queue]
set :rvm_map_bins, fetch(:rvm_map_bins, []) + %w(eye)
set :rvm_ruby_version, '2.3.1'

set :default_env, rails_env: fetch(:stage)

set :webdav_favicon, '8f56f789' # Settings.favicon_hash

set :webdav_headers, { host: 'webdav.park.rambler.ru' }

set :webdav_paths_backend, [
  'assets/admin/**/*.*',
  'assets/bootstrap/**/*.*',
  'assets/icons/**/*.*',
  'assets/tinymce/**/*.*',
  'assets/chosen-*.*',
  'assets/fontawesome-webfont-*.*',
  'assets/tinymce-*.*',
  'assets/.sprockets-manifest-*'
]

set :webdav_paths_front, [
  'assets/front/**/*.*',
  'assets/mobile/**/*.*',
  'assets/.sprockets-manifest-*',
  '*.*'
]

task :upload_bundle_config do
  on roles(fetch(:bundle_roles)) do
    within shared_path do
      config = File.expand_path('../../.bundle_config', __FILE__)

      execute(:mkdir, '-p', '.bundle')
      upload!(config, shared_path.join('.bundle/config'))
    end
  end
end

task :copy_bundle_config do
  on roles(fetch(:bundle_roles)) do
    within shared_path do
      destination = release_path.join('.bundle')

      execute(:mkdir, '-p', destination)
      execute(:cp, '.bundle/config', destination.join('config'))
    end
  end
end

before 'bundler:install', 'copy_bundle_config'
