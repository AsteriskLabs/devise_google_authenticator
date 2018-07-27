module DeviseGoogleAuthenticator
  module Generators # :nodoc:
    # Install Generator
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Install the devise google authenticator extension"

      def add_configs
        default_config_instructions = <<-HEREDOC
        # ==> Devise Google Authenticator Extension
        # Configure extension for devise

        # How long should the user have to enter their token. To change the default, uncomment and change the line below:
        # config.ga_timeout = 3.minutes

        # Change time drift settings for valid token values. To change the default, uncomment and change the line below:
        # config.ga_timedrift = 3

        # Change setting to how long to remember devise before requiring another token. Change to nil to turn feature off.
        # To change the default, uncomment and change the line below:
        # config.ga_remembertime = 1.month

        # Change setting to assign the application name used by code generator. Defaults to `Rails.application.class.parent_name`.
        # To change the default, uncomment and change the line below:
        # config.ga_appname = 'example.com'

        # Change setting to bypass the Display QR page immediately after a user signs up
        # To change the default, uncomment and change the line below. [Default: false]
        # config.ga_bypass_signup = true
        HEREDOC

        inject_into_file "config/initializers/devise.rb", default_config_instructions, before: /end\s*\Z/
      end

      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/devise.google_authenticator.en.yml"
      end
    end
  end
end
