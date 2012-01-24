require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "rails/test_unit/railtie"

Bundler.require(:default, DEVISE_ORM) if defined?(Bundler)

begin
  require "#{DEVISE_ORM}/railtie"
rescue LoadError
end
PARENT_MODEL_CLASS = DEVISE_ORM == :active_record ? ActiveRecord::Base : Object

require "devise"
require "devise_google_authenticator"

module RailsApp
  class Application < Rails::Application
    config.filter_parameters << :password
  end
end
