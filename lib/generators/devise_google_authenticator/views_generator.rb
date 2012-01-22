require 'generators/devise/views_generator'

module DeviseGoogleAuthenticator
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      desc 'Copies all Devise Google Authenticator views to your application.'

      argument :scope, :required => false, :default => nil,
                       :desc => "The scope to copy views to"

      include ::Devise::Generators::ViewPathTemplates
      source_root File.expand_path("../../../../app/views/devise", __FILE__)
      def copy_views
        view_directory :checkga
        view_directory :displayqr
      end
    end
  end
end
