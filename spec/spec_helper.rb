ENV["RAILS_ENV"] ||= 'test'

require 'simplecov'
SimpleCov.start

require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require 'factory_girl_rails'
require 'shoulda-matchers'
require 'database_cleaner'
require 'pry-rails'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
