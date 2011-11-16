require 'rotp'
require 'devise_google_authenticatable/hooks/google_authenticatable'

module Devise # :nodoc:
  module Models # :nodoc:

    module GoogleAuthenticatable

      def self.included(base) # :nodoc:
        base.extend ClassMethods

        base.class_eval do
          before_validation :assign_auth_secret, :on => :create
          include InstanceMethods
        end
      end

      module InstanceMethods # :nodoc:
        def get_qr
          self.gauth_secret
        end
        
        def set_gauth_enabled(param)
          self.update_without_password(param)
        end

        private

        def assign_auth_secret
          self.gauth_secret = ROTP::Base32.random_base32
        end
        
      end

      module ClassMethods # :nodoc:
        #Something here?
      end
    end
  end
end
