require 'rotp'

module Devise #:nodoc:
  module Models #:nodoc:
    module GoogleAuthenticatable #:nodoc:
      def self.included(base) #:nodoc:
        base.extend ClassMethods

        base.class_eval do
          before_validation :assign_auth_secret, :on => :create
          include InstanceMethods
        end
      end

      module InstanceMethods #:nodoc:
        def get_qr
          self.gauth_secret
        end

        def set_gauth_enabled(param)
          #self.update_without_password(params[gauth_enabled])
          self.update_attributes(gauth_enabled: param)
        end

        def assign_tmp
          self.update_attributes(gauth_tmp: ROTP::Base32.random_base32(32), gauth_tmp_datetime: DateTime.now)
          self.gauth_tmp
        end

        def validate_token(token)
          return false unless self.gauth_tmp_datetime
          return false if self.gauth_tmp_datetime < self.class.ga_timeout.ago

          valid_vals = []
          valid_vals << ROTP::TOTP.new(self.get_qr).at(Time.now)
          (1..self.class.ga_timedrift).each do |cc|
            valid_vals << ROTP::TOTP.new(self.get_qr).at(Time.now.ago(30*cc))
            valid_vals << ROTP::TOTP.new(self.get_qr).at(Time.now.in(30*cc))
          end

          return valid_vals.include?(token.to_i)
        end

        def gauth_enabled?
          if self.gauth_enabled.respond_to?(:to_i)
            # Active_record seems to handle determining the status better this way
            return self.gauth_enabled.to_i != 0
          else
            # Mongoid does NOT have a .to_i for the Boolean return value, hence we can just return it
            return self.gauth_enabled
          end
        end

        def require_token?(cookie)
          return true if self.class.ga_remembertime.nil? || cookie.blank?

          array = cookie.to_s.split ','

          return true if array.count != 2

          last_logged_in_email = array[0]
          last_logged_in_time = array[1].to_i

          return last_logged_in_email != self.email || (Time.now.to_i - last_logged_in_time) > self.class.ga_remembertime.to_i
        end

        private

        def assign_auth_secret
          self.gauth_secret = ROTP::Base32.random_base32(64)
        end
      end

      module ClassMethods #:nodoc:
        def find_by_gauth_tmp(gauth_tmp)
          where(gauth_tmp: gauth_tmp).first
        end

        ::Devise::Models.config(self, :ga_timeout, :ga_timedrift, :ga_remembertime, :ga_appname, :ga_bypass_signup)
      end
    end
  end
end
