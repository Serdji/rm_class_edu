require 'dotenv'
Dotenv.load '.env.local'

require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/rvm'

require 'capistrano/rails/migrations'
require 'capistrano/rails/assets'
require 'capistrano/webdav'
require 'whenever/capistrano'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
