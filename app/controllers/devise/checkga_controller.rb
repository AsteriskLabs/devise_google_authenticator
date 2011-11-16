class Devise::CheckgaController < Devise::SessionsController
  
#  include Devise::Controllers::InternalHelpers
  
  def show
    render_with_scope :show
  end
  
  def update
    sign_in(resource_name, resource)
    respond_with resource, :location => redirect_location(resource_name, resource)
  end
end