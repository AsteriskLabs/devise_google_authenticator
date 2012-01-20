require 'rotp'
#require 'devise_google_authenticatable/hooks/google_authenticatable'

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
        
        def login_phase_one
          return "yep"
        end

        def assign_tmp
          self.update_attributes(:gauth_tmp => ROTP::Base32.random_base32, :gauth_tmp_datetime => DateTime.now)
          self.gauth_tmp
        end

        private

        def assign_auth_secret
          self.gauth_secret = ROTP::Base32.random_base32
        end
        
      end

      module ClassMethods # :nodoc:
        def find_by_gauth_tmp(gauth_tmp)
          find(:first, :conditions => {:gauth_tmp => gauth_tmp})
        end
      end
    end
  end
end
