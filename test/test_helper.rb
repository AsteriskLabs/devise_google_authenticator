ENV["RAILS_ENV"] = "test"
DEVISE_ORM = (ENV["DEVISE_ORM"] || :active_record).to_sym

FileUtils.rm_f('./rails_app/db/test.sqlite3') # Remove test database before each test run

$:.unshift File.dirname(__FILE__)
puts "\n==> Devise.orm = #{DEVISE_ORM.inspect}"
require "rails_app/config/environment"
require "orm/#{DEVISE_ORM}"
require 'rails/test_help'
require 'capybara/rails'
require 'timecop'
require 'byebug'

I18n.load_path << File.expand_path('support/locale/en.yml', __dir__) if DEVISE_ORM == :mongoid

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end
