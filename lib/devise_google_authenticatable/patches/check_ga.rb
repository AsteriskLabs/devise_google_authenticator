module DeviseGoogleAuthenticator::Patches
  # patch Sessions controller to check that the OTP is accurate
  module CheckGA
    extend ActiveSupport::Concern
    included do
    # here the patch
    # CF TODO - check for gauth_enabled, check gauth_secret, then call original

      alias_method :create_original, :create
      define_method :create do
        resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
        #set_flash_message(:notice, :signed_in) if is_navigational_format?
        #sign_in(resource_name, resource)
        respond_with resource, :location => {:controller => 'checkga', :action => 'show'}
      end
    end
  end
end
