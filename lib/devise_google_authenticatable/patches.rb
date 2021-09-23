module DeviseGoogleAuthenticator
  module Patches
    autoload :DisplayQR, 'devise_google_authenticatable/patches/display_qr'
    autoload :CheckGA, 'devise_google_authenticatable/patches/check_ga'

    class << self
      def apply
        Devise::RegistrationsController.include Patches::DisplayQR
        Devise::SessionsController.include Patches::CheckGA
      end
    end
  end
end
