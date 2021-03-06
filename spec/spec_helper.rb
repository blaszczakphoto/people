if ENV['CI']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'webmock/rspec'
require 'sucker_punch/testing/inline'
require 'capybara/rspec'
require 'rack_session_access/capybara'
require 'database_cleaner'


ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  I18n.enforce_available_locales = false
  WebMock.disable_net_connect!(allow_localhost: true,
                               allow: [/rest/, /codeclimate.com/])

  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.include Helpers::JSONResponse, type: :controller
  config.include Capybara::DSL

  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, job: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    Timecop.return
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = false
end

Capybara.default_max_wait_time = 5

Capybara.javascript_driver = :webkit
