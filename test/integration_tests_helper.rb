class ActionController::IntegrationTest

  def warden
    request.env['warden']
  end
  
  def create_full_user
    @@user ||= begin
      user = User.create!(
        :username              => 'usertest',
        :email                 => 'fulluser@test.com',
        :password              => '123456',
        :password_confirmation => '123456'
      )
      @@user = user
      user
    end
  end

  def create_and_signin_gauth_user
    testuser = create_full_user
    sign_in_as_user(testuser)
    visit user_displayqr_path
    check 'user_gauth_enabled'
    fill_in('user_gauth_token', :with => ROTP::TOTP.new(testuser.get_qr).at(Time.now))
    click_button 'Continue...'

    Capybara.reset_sessions!

    sign_in_as_user(testuser)
    testuser
  end

  def sign_in_as_user(user = nil)
    user ||= create_full_user
    resource_name = user.class.name.underscore
    visit send("new_#{resource_name}_session_path")
    fill_in "#{resource_name}_email", :with => user.email
    fill_in "#{resource_name}_password", :with => user.password
    click_button 'Log in'
  end
end
