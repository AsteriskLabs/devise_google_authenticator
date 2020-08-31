class ActionDispatch::IntegrationTest
  def warden
    request.env['warden']
  end

  def test_user
    @test_user ||= User.find_by(email: 'fulluser@test.com') || User.create(email: "fulluser@test.com", password: '123456', password_confirmation: '123456')
  end
  
  def create_full_user
    test_user # For compatibility in tests
  end

  def create_and_signin_gauth_user
    test_user.set_gauth_enabled(0) # Reset to off to allow turning on to work
    sign_in_as_user(test_user)
    visit user_displayqr_path
    check 'user_gauth_enabled'
    fill_in('user_gauth_token', with: ROTP::TOTP.new(test_user.get_qr).at(Time.now))
    click_button 'Continue...'

    Capybara.reset_sessions!

    sign_in_as_user(test_user)
    test_user
  end

  def sign_in_as_user(user = nil)
    user ||= test_user
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: '123456'
    click_button 'Log in'
  end
end
