module DeviseGoogleAuthenticator::Patches
  # patch Registrations controller to display the QR code
  module DisplayQR
    extend ActiveSupport::Concern
    included do
      
      #arrr be the patch
      alias_method :create_original, :create

      define_method :create do
        build_resource

        if resource.save
          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_navigational_format?
            sign_in(resource_name, resource)
            
            respond_with resource, :location => {:controller => 'displayqr', :action => 'show'}
          else
            set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
            expire_session_data_after_sign_in!
            respond_with resource, :location => after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords(resource)
          respond_with_navigational(resource) { render_with_scope :new }
        end
      end
    end
  end
end
