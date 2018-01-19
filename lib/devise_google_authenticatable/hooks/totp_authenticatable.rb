Warden::Manager.after_authentication do |user, auth, options|
  gauth_enabled = true
  gauth_enabled = user.gauth_enabled? if user.respond_to?(:gauth_enabled?)

  if gauth_enabled
    if user.respond_to?(:with_totp_authentication?)
      with_totp_authentication = user.with_totp_authentication?
      # Build Warden scope from user class name
      user_scope = user.class.name.underscore.to_sym
      # Ensure Warden knows about it
      if auth.config[:default_strategies].keys.include?(user_scope)
        scope = auth.session(user_scope)
        scope[:with_totp_authentication] = with_totp_authentication
      end
    end
  end
end
