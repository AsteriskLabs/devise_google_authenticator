require 'rotp'

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

        def set_gauth_enabled(params)
          self.update_without_password(params)
        end

        def assign_tmp
          self.update_attributes(:gauth_tmp => ROTP::Base32.random_base32(32), :gauth_tmp_datetime => DateTime.now)
          self.gauth_tmp
        end

        def validate_token(token)
          return false if self.gauth_tmp_datetime.nil?
          if self.gauth_tmp_datetime < self.class.ga_timeout.ago
            return false
          else

            valid_vals = []
            valid_vals << ROTP::TOTP.new(self.get_qr).at(Time.now)
            (1..self.class.ga_timedrift).each do |cc|
              valid_vals << ROTP::TOTP.new(self.get_qr).at(Time.now.ago(30*cc))
              valid_vals << ROTP::TOTP.new(self.get_qr).at(Time.now.in(30*cc))
            end

            if valid_vals.include?(token.to_i)
              return true
            else
              return false
            end
          end
        end

        def require_token?(cookie)
          if self.class.ga_remembertime.nil? || cookie.blank?
            return true
          end
          array = cookie.to_s.split ','
          if array.count != 2
            return true
          end
          last_logged_in_email = array[0]
          last_logged_in_time = array[1].to_i
          return last_logged_in_email != self.email || (Time.now.to_i - last_logged_in_time) > self.class.ga_remembertime.to_i
        end

        private

        def assign_auth_secret
          self.gauth_secret = ROTP::Base32.random_base32(64)
        end

      end

      module ClassMethods # :nodoc:
        def find_by_gauth_tmp(gauth_tmp)
          find(:first, :conditions => {:gauth_tmp => gauth_tmp})
        end
        ::Devise::Models.config(self, :ga_timeout, :ga_timedrift, :ga_remembertime)
      end
    end
  end
end
