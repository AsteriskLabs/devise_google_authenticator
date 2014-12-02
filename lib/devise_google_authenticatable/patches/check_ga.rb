module DeviseGoogleAuthenticator::Patches
  # patch Sessions controller to check that the OTP is accurate
  module CheckGA
    extend ActiveSupport::Concern
    included do
    # here the patch

      alias_method :create_original, :create

      define_method :checkga_resource_path_name do |resource, id|
        name = resource.class.name.singularize.underscore
        name = name.split('/').last
        "#{name}_checkga_path(id:'#{id}')"
      end

      define_method :create do

        resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")

        if resource.respond_to?(:get_qr) and resource.gauth_enabled? and resource.require_token?(cookies.signed[:gauth]) #Therefore we can quiz for a QR
          tmpid = resource.assign_tmp #assign a temporary key and fetch it
          warden.logout #log the user out

          #we head back into the checkga controller with the temporary id
          #Because the model used for google auth may not always be the same, and may be a sub-model, the eval will evaluate the appropriate path name
          #This change addresses https://github.com/AsteriskLabs/devise_google_authenticator/issues/7
          respond_with resource, :location => eval(checkga_resource_path_name(resource, tmpid))

        else #It's not using, or not enabled for Google 2FA, OR is remembering token and therefore not asking for the moment - carry on, nothing to see here.
          set_flash_message(:notice, :signed_in) if is_flashing_format?
          sign_in(resource_name, resource)
          respond_with resource, :location => after_sign_in_path_for(resource)
        end

      end
    end
  end
end
