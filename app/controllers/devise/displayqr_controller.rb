class Devise::DisplayqrController < DeviseController
  prepend_before_action :authenticate_scope!, only: [:show, :update, :refresh]

  include Devise::Controllers::Helpers

  # GET /resource/displayqr
  def show
    if resource&.gauth_secret.nil?
      sign_in resource_class.new, resource
      redirect_to stored_location_for(scope) || :root
    else
      @tmpid = resource.assign_tmp
      render :show
    end
  end

  def update
    if resource.gauth_tmp != params[resource_name]['tmpid'] || !resource.validate_token(params[resource_name]['gauth_token'])
      set_flash_message(:error, :invalid_token)
      render :show
      return
    end

    if resource.set_gauth_enabled(params[resource_name]['gauth_enabled'])
      set_flash_message :notice, (resource.gauth_enabled? ? :enabled : :disabled)
      bypass_sign_in resource, scope: scope
      redirect_to stored_location_for(scope) || :root
    else
      render :show
    end
  end

  def refresh
    unless resource.nil?
      resource.send(:assign_auth_secret)
      resource.save
      set_flash_message :notice, :newtoken
      bypass_sign_in resource, scope: scope
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
    send(:"authenticate_#{resource_name}!")
    self.resource = send("current_#{resource_name}")
  end
end
