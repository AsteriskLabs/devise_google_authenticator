module DeviseGoogleAuthenticator
  class Engine < ::Rails::Engine # :nodoc:
    ActionDispatch::Callbacks.to_prepare do
      DeviseGoogleAuthenticator::Patches.apply
    end

    ActiveSupport.on_load(:action_controller) do
      include DeviseGoogleAuthenticator::Controllers::Helpers
    end
  end
end
