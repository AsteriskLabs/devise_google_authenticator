class Devise::CheckgaController < Devise::SessionsController
  prepend_before_filter :devise_resource, :only => [:show]
  prepend_before_filter :require_no_authentication, :only => [ :show, :update ]

  include Devise::Controllers::Helpers

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

    if not resource.nil?

      if resource.validate_token(params[resource_name]['gauth_token'].to_i)
        set_flash_message(:notice, :signed_in) if is_navigational_format?
        sign_in(resource_name,resource)
        respond_with resource, :location => after_sign_in_path_for(resource)
      else
        redirect_to :root
      end

    else
      redirect_to :root
    end
  end

  private

  def devise_resource
    self.resource = resource_class.new
  end
end