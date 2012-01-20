class Devise::CheckgaController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [ :show, :update ]
  include Devise::Controllers::InternalHelpers
  
  def show
    @tmpid = params[:id]
    if @tmpid.nil?
      redirect_to :root
    else
      render_with_scope :show
    end
  end
  
  def update
    resource = resource_class.find_by_gauth_tmp(params[resource_name]['tmpid'])

    if not resource.nil?

      if resource.gauth_tmp_datetime < 10.minutes.ago
        puts "Too slow"
        redirect_to :root
      else
      
        valid_vals = []
        valid_vals << ROTP::TOTP.new(resource.get_qr).at(Time.now)
        (1..3).each do |cc|
          valid_vals << ROTP::TOTP.new(resource.get_qr).at(Time.now.ago(30*cc))
          valid_vals << ROTP::TOTP.new(resource.get_qr).at(Time.now.in(30*cc))
        end
        
        if valid_vals.include?(params[resource_name]['token'].to_i)
          set_flash_message(:notice, :signed_in) if is_navigational_format?
          sign_in(resource_name,resource)
          respond_with resource, :location => redirect_location(resource_name, resource)
        else
          redirect_to :root
        end
      end
    else
      redirect_to :root
    end
  end
end