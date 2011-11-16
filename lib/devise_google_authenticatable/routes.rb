module ActionDispatch::Routing # :nodoc:
  class Mapper # :nodoc:

    protected

    # route for handle expired passwords
    def devise_displayqr(mapping, controllers)
      resource :displayqr, :only => [:show, :update], :path => mapping.path_names[:displayqr], :controller => controllers[:displayqr]
      resource :checkga, :only => [:show, :update], :path => mapping.path_names[:checkga], :controller => controllers[:checkga]
    end

  end
end

