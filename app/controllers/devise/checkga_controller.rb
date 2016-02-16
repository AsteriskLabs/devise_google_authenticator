class Devise::CheckgaController < Devise::SessionsController
  prepend_before_filter :devise_resource, only: [:show]
  prepend_before_filter :require_no_authentication, only: [:show, :update]

  include Devise::Controllers::Helpers
  class ErrorSigningIn < StandardError; end

  def show
    @tmpid = params[:id]
    if @tmpid.nil?
      redirect_to :root
    else
      render :show
    end
  end

  def update
    resource = resource_class.find_by_gauth_tmp(params[resource_name]['tmpid'])

    fail ErrorSigningIn unless resource
    fail ErrorSigningIn unless resource.validate_token(params[resource_name]['gauth_token'].to_i)

    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name,resource)
    warden.manager._run_callbacks(:after_set_user, resource, warden, event: :authentication)

    gauth_cookie = {
      value: [resource.email, Time.now.to_i.to_s].join(','),
      secure: !(Rails.env.test? || Rails.env.development?),
      expires: (resource.class.ga_remembertime + 1.day).from_now
    }
    cookies.signed[:gauth] = gauth_cookie if resource.class.ga_remembertime

    respond_with resource, location: after_sign_in_path_for(resource)
  rescue ErrorSigningIn
    set_flash_message(:error, :error)
    redirect_to :root
  end

  private

  def devise_resource
    self.resource = resource_class.new
  end
end
