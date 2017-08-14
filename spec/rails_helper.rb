ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

if Rails.env.production?
  abort 'The Rails environment is running in production mode!'
end

Dir[Rails.root.join('spec/supports/**/*.rb')].each { |file| require(file) }

require 'spec_helper'
require 'rspec/rails'

require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end

require 'rake'
Rake.load_rakefile(Rails.root.join('Rakefile'))

# Checks for pending migration and applies them before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Automatically mix in different behaviours to your tests.
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  # Factory Girl
  config.include FactoryGirl::Syntax::Methods

  # Devise
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation

    Rake::Task['db:seed:roles'].invoke
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
