module DeviseGoogleAuthenticator
  module Generators # :nodoc:
    # Install Generator
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Install the devise google authenticator extension"

      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/devise.google_authenticator.en.yml"
      end
    end
  end
end