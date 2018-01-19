module DeviseGoogleAuthenticator
  module Patches
    autoload :DisplayQR, 'devise_google_authenticatable/patches/display_qr'

    class << self
      def apply
        Devise::RegistrationsController.send(:include, Patches::DisplayQR)
      end
    end
  end
end
