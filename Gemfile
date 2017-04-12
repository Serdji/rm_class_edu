source 'http://art.rambler.ru/api/gems/gems/'

git_source(:gitlab) { |repo| "https://gitlab.rambler.ru/#{repo}.git" }

gem 'carrierwave', '~> 0.11.2'
gem 'pg',          '~> 0.18'
gem 'rails',       '~> 5.1.0.rc1'

gem 'draper', gitlab: 'a.pokhozhaev/draper', branch: :master

gem 'eye'

gem 'sentry-raven', require: false

gem 'newrelic_rpm'
gem 'redis-rails'
gem 'redis-session-store'
gem 'resque'
gem 'sinatra', '>= 2.0.0.beta2', require: false

gem 'therubyracer'
gem 'prometheus-client'

gem 'browser'
gem 'active_model_serializers', '~> 0.10.0'
gem 'tinymce-rails', '~> 4.3', '>= 4.3.13'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'chosen-rails'
gem 'selectize-rails'
gem 'font-awesome-rails'
gem 'jquery-rails'
gem 'sass-rails', '>= 5.0.6'
gem 'slim-rails'
gem 'underscore-rails'
gem 'autoprefixer-rails'

gem 'carrierwave-webdav', gitlab: 'a.pokhozhaev/carrierwave-webdav'
gem 'webpack-pipeline',   gitlab: 'a.pokhozhaev/webpack-pipeline', branch: :master
gem 'kramdown',           gitlab: 'a.pokhozhaev/kramdown', tag: 'REL_1_11_2'
gem 'rid',                gitlab: 'a.pokhozhaev/rid', branch: :develop

gem 'capistrano-webdav', '~> 0.0.1', gitlab: 'i.simdyanov/capistrano-webdav',
                                     require: 'capistrano/webdav/engine'

gem 'bootstrap3-datetimepicker-rails', '~> 4.17.37'
gem 'momentjs-rails', '>= 2.9.0'
gem 'uglifier'

gem 'devise'
gem 'diffy'
gem 'paper_trail', '>= 5.2'
gem 'ransack', '~> 1.8.0'
gem 'ruby-progressbar'
gem 'russian'

gem 'will_paginate', gitlab: 'a.pokhozhaev/will_paginate', branch: 'gap'
gem 'will_paginate-bootstrap'

gem 'awesome_nested_set', '~> 3.1'
gem 'config'
gem 'dotenv-rails'
gem 'faker'
gem 'sitemap_generator'
gem 'sprockets-es6'
gem 'whenever', require: false
gem 'her'
gem 'faraday-http-cache'
gem 'faraday_middleware'
gem 'virtus'

gem 'rmagick'

group :development, :test do
  gem 'ruby-prof'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'simplecov'
  gem 'thin'
end

group :development do
  gem 'binding_of_caller'
  gem 'rubocop'

  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false

  gem 'rack-mini-profiler', require: false
  gem 'stackprof'
  gem 'flamegraph'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'fakeredis', require: 'fakeredis/rspec'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'webmock', require: false
end

group :production, :staging do
  gem 'unicorn'
end
