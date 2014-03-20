require 'rails/generators/named_base'
require 'generators/devise/orm_helpers'

module Mongoid
  module Generators
    class DeviseGoogleAuthenticatorGenerator < Rails::Generators::NamedBase
      include Devise::Generators::OrmHelpers

      def inject_field_types
        inject_into_file model_path, migration_data, :after => "include Mongoid::Document\n" if model_exists?
      end

      def migration_data
<<RUBY
  # Google Authenticator
  field :gauth_secret, :type => String
  field :gauth_enabled, :type => Boolean, :default => 'f'
  field :gauth_tmp, :type => String
  field :gauth_tmp_datetime, :type => DateTime

RUBY
      end
    end
  end
end

