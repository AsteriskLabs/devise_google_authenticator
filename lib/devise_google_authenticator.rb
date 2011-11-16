require 'active_record/connection_adapters/abstract/schema_definitions'
require 'active_support/core_ext/integer'
require 'active_support/core_ext/string'
require 'active_support/ordered_hash'
require 'active_support/concern'
require 'devise'

# a security extension for devise
module DeviseGoogleAuthenticator
  autoload :Schema, 'devise_google_authenticatable/schema'
  autoload :Patches, 'devise_google_authenticatable/patches'
  
#  module Controllers # :nodoc:
#    autoload :Helpers, 'devise_google_authenticatable/controllers/helpers'
#  end
end



require 'devise_google_authenticatable/routes'
require 'devise_google_authenticatable/rails'
require 'devise_google_authenticatable/orm/active_record'
require 'devise_google_authenticatable/controllers/helpers'
ActionView::Base.send :include, DeviseGoogleAuthenticator::Controllers::Helpers

Devise.add_module :google_authenticatable, :controller => :google_authenticatable, :model => 'devise_google_authenticatable/models/google_authenticatable', :route => :displayqr