bundle exec rake db:create
bundle exec rake db:environment:set RAILS_ENV=test
bundle exec rake db:schema:load

bundle exec rake projects:reset
bundle exec rails s -p 3001
