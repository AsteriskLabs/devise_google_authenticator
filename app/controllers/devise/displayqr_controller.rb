class Devise::DisplayqrController < ApplicationController
  prepend_before_filter :authenticate_scope!, :only => [:show,:update]
  
  include Devise::Controllers::InternalHelpers
  
  def show
    if not resource.nil? and not resource.gauth_secret.nil?
      render_with_scope :show
    else
      sign_in scope, resource, :bypass => true
      redirect_to stored_location_for(scope) || :root
    end
  end
  
  def update
    tmp = params[resource_name]
    if resource.set_gauth_enabled(params[resource_name])
      set_flash_message :notice, "Status Updated!"
      sign_in scope, resource, :bypass => true
      redirect_to stored_location_for(scope) || :root
    else
      render_with_scope :show
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