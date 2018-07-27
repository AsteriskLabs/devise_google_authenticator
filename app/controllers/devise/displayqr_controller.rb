class Devise::DisplayqrController < DeviseController
  prepend_before_filter :authenticate_scope!, only: [:show, :update, :refresh]

  include Devise::Controllers::Helpers
  class InvalidToken < StandardError; end

  # GET /{resource}/displayqr
  def show
    if resource && resource.gauth_secret
      @tmpid = resource.assign_tmp
      render :show
    else
      sign_in resource_class.new, resource
      redirect_to stored_location_for(scope) || :root
    end
  end

  def update
    fail InvalidToken if resource.gauth_tmp != params[resource_name]['tmpid']
    fail InvalidToken unless resource.validate_token(params[resource_name]['gauth_token'].to_i)

    if resource.set_gauth_enabled(params[resource_name]['gauth_enabled'])
      set_flash_message :notice, (resource.gauth_enabled? ? :enabled : :disabled)
      sign_in scope, resource, bypass: true
      redirect_to stored_location_for(scope) || :root
    else
      render :show
    end
  rescue InvalidToken
    set_flash_message(:error, :invalid_token)
    render :show
  end

  def refresh
    if resource
      resource.send(:assign_auth_secret)
      resource.save

      set_flash_message(:notice, :newtoken)
      sign_in(scope, resource, bypass: true)
      redirect_to [resource_name, :displayqr]
    else
      redirect_to :root
    end
  end

  private

  def scope
    resource_name.to_sym
  end

  def authenticate_scope!
    send("authenticate_#{resource_name}!")
    self.resource = send("current_#{resource_name}")
  end

  # 7/2/15 - Unsure if this is used anymore - @xntrik
  def resource_params
    if defined?(ActionController::StrongParameters)
      params.require(resource_name.to_sym).permit(:gauth_enabled)
    else
      params
    end
  end
end
