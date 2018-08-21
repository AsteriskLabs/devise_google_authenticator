module DeviseGoogleAuthenticator
  class Engine < ::Rails::Engine # :nodoc:
    ActiveSupport::Reloader.to_prepare do
      DeviseGoogleAuthenticator::Patches.apply
    end

  end
end
