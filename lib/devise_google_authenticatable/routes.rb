module ActionDispatch::Routing # :nodoc:
  class Mapper # :nodoc:

    protected

    # route for handle expired passwords
    def devise_displayqr(mapping, controllers)
      resource :displayqr, :only => [:show, :update], :path => mapping.path_names[:displayqr], :controller => controllers[:displayqr] do
      	post :refresh, :path => mapping.path_names[:refresh], :as => :refresh
      end
      resource :checkga, :only => [:show, :update], :path => mapping.path_names[:checkga], :controller => controllers[:checkga]
    end

  end
end

