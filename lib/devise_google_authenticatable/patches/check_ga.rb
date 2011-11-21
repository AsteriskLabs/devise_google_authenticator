module DeviseGoogleAuthenticator::Patches
  # patch Sessions controller to check that the OTP is accurate
  module CheckGA
    extend ActiveSupport::Concern
    included do
    # here the patch

      alias_method :create_original, :create
      
      #Below is trial 1 .. over-writing most of the create method
      #Whilst this works, I wish it was about a gazillion times cleaner
      
      define_method :create do
        #Okay, firstly we grab the resource, if the user stuffs up anything, this dies immediately.
        #This actually authenticates their password
        resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")

        #Okay, check that the resource model includes the get_qr method
        if resource.respond_to?(:get_qr) #Therefore we can quiz for a QR

          # Okay, we have the method to get the qr secret, lets check if the user has gauth enabled
          if resource.gauth_enabled.to_i != 0 #gauth_enabled is not set to zero, therefore it's ON!
            
            # Orite, At this point the user model includes the extension stuff
            # PLUS, gauth_enabled is ON, so lets try and authenticate .. but first
            
            # Lets check if the "POST" includes the gauth_submit parameter
            if params.fetch(resource_name).include?("gauth_submit") #Yep, the browser submitted the gauth_submit - OTP
              
              #Okay, lets get what they submitted in the form, crunch it into an int
              submitted_value = params.fetch(resource_name).fetch("gauth_submit").to_i
              
              #By default, gauth is not successful
              gauth_successful = false
              
              if submitted_value == 0 #We have a field, but they've left it blank..
                #Nothing, they left the field blank, and therefore will not sign in, gauth_successfull remains false
              else
                #Okay, they submitted something into the OTP field
              
                #Lets account for the fact the timing may not always be accurate, so go backwards, current and forwards
                #If the submitted OTP matches, then gauth_successful is true - YAY for you! .. Yay for you indeed.
                
                #CF TODO: Do some checking here, how late can these codes be??
                if submitted_value == ROTP::TOTP.new(resource.get_qr).at(Time.now.ago(30))
                  gauth_successful = true
                elsif submitted_value == ROTP::TOTP.new(resource.get_qr).at(Time.now)
                  gauth_successful = true
                elsif submitted_value == ROTP::TOTP.new(resource.get_qr).at(Time.now.in(30))
                  gauth_successful = true
                end
              end
              
              if gauth_successful == true #That means the OTP actually worked, lets log 'em in
                set_flash_message(:notice, :signed_in) if is_navigational_format?
                sign_in(resource_name, resource)
                respond_with resource, :location => redirect_location(resource_name, resource)
              else #That means that, the OTP did NOT line up properly, lets kick 'em back to the start
                signed_in = signed_in?(resource_name)
                Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
                resource = build_resource
                clean_up_passwords(resource)
                respond_with resource, :location => {:controller => 'sessions', :action => 'new'}
              end
              
            else #Okay, this is odd, the user is all set to go, but the browser did NOT include the OTP, tampering occurred
              # OR - the developer did NOT modify the "sessions" view to include 
              # TODO: What should they put in the view again?
              
              #At this point, we're going to log them back out and send them back to the start
              signed_in = signed_in?(resource_name)
              Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
              resource = build_resource
              clean_up_passwords(resource)
              respond_with resource, :location => {:controller => 'sessions', :action => 'new'}
            end
          else #gauth_enabled must have been set to zero, therefore it's off .. lets just continue with the original sign in process
            set_flash_message(:notice, :signed_in) if is_navigational_format?
            sign_in(resource_name, resource)
            respond_with resource, :location => redirect_location(resource_name, resource)
          end
        else #It looks like the model did NOT include the get_qr method .. lets just continue with the original sign in process
          set_flash_message(:notice, :signed_in) if is_navigational_format?
          sign_in(resource_name, resource)
          respond_with resource, :location => redirect_location(resource_name, resource)
        end
      end
    end
  end
end
