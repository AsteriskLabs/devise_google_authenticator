require 'rotp'

module Devise # :nodoc:
  module Models # :nodoc:
    module GoogleAuthenticatable
      def self.included(base) # :nodoc:
        base.extend ClassMethods

        base.class_eval do
          before_validation :assign_auth_secret, on: :create
          include InstanceMethods
        end
      end

      module InstanceMethods # :nodoc:
        def get_qr # rubocop:todo Naming/AccessorMethodName
          gauth_secret
        end

        def set_gauth_enabled(param) # rubocop:todo Naming/AccessorMethodName
          update_attributes(gauth_enabled: param)
        end

        def assign_tmp
          update_attributes(gauth_tmp: ROTP::Base32.random(32), gauth_tmp_datetime: DateTime.now)
          gauth_tmp
        end

        def validate_token(token) # rubocop:todo Metrics/AbcSize
          return false if gauth_tmp_datetime.nil?

          if gauth_tmp_datetime < self.class.ga_timeout.ago
            false
          else

            valid_vals = []
            valid_vals << ROTP::TOTP.new(get_qr).at(Time.now)
            (1..self.class.ga_timedrift).each do |cc|
              valid_vals << ROTP::TOTP.new(get_qr).at(Time.now.ago(30 * cc))
              valid_vals << ROTP::TOTP.new(get_qr).at(Time.now.in(30 * cc))
            end

            if valid_vals.include?(token)
              true
            else
              false
            end
          end
        end

        def gauth_enabled?
          # Active_record seems to handle determining the status better this way
          if gauth_enabled.respond_to?("to_i")
            !(gauth_enabled.to_i == 0)
          # Mongoid does NOT have a .to_i for the Boolean return value, hence, we can just return it
          else
            gauth_enabled
          end
        end

        def require_token?(cookie) # rubocop:todo Metrics/AbcSize
          return true if self.class.ga_remembertime.nil? || cookie.blank?

          array = cookie.to_s.split ','
          return true if array.count != 2

          last_logged_in_email = array[0]
          last_logged_in_time = array[1].to_i
          last_logged_in_email != email || (Time.now.to_i - last_logged_in_time) > self.class.ga_remembertime.to_i
        end

        private

        def assign_auth_secret
          self.gauth_secret = ROTP::Base32.random(64)
        end
      end

      module ClassMethods # :nodoc:
        ::Devise::Models.config(self, :ga_timeout, :ga_timedrift, :ga_remembertime, :ga_appname, :ga_bypass_signup)
      end
    end
  end
end
