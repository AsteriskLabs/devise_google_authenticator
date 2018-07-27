module DeviseGoogleAuthenticator::Patches #:nodoc:
  # patch Registrations controller to display the QR code
  module DisplayQR
    extend ActiveSupport::Concern

    included do
      # arrr be the patch
      alias_method :create_original, :create

      define_method :create do
        build_resource(sign_up_params)

        unless resource.save
          # Error! Abort!
          clean_up_passwords resource
          return respond_with resource
        end

        yield resource if block_given?

        unless resource.active_for_authentication?
          #
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          return respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end

        set_flash_message :notice, :signed_up if is_flashing_format?

        sign_in(resource_name, resource)

        unless resource.respond_to? :gauth_enabled?
          return respond_with resource, location: after_sign_up_path_for(resource)
        end

        if resource.class.ga_bypass_signup
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          respond_with resource, location: { controller: 'displayqr', action: 'show' }
        end
      end
    end
  end
end
