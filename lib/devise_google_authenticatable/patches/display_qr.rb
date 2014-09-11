module DeviseGoogleAuthenticator::Patches
  # patch Registrations controller to display the QR code
  module DisplayQR
    extend ActiveSupport::Concern
    included do
      
      #arrr be the patch
      alias_method :create_original, :create

      define_method :create do
        build_resource(sign_up_params)

        if resource.save
          yield resource if block_given?
          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_flashing_format?
            sign_in(resource_name, resource)
            
            if resource.respond_to? :gauth_enabled?
              if resource.class.ga_bypass_signup
                respond_with resource, location: after_sign_up_path_for(resource)
              else
                respond_with resource, :location => {:controller => 'displayqr', :action => 'show'}
              end
            else
              respond_with resource, location: after_sign_up_path_for(resource)
            end

          else
            set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
            expire_data_after_sign_in!
            respond_with resource, :location => after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords resource
          respond_with resource
        end
      end
    end
  end
end
