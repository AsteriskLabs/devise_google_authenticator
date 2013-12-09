require 'test_helper'
require 'integration_tests_helper'

class InvitationTest < ActionDispatch::IntegrationTest
  def teardown
    Capybara.reset_sessions!
    Timecop.return
  end

  test 'register new user - confirm that we get a display qr page after registering' do
    visit new_user_registration_path
    fill_in 'user_email', :with => 'test@test.com'
    fill_in 'user_password', :with => 'password'
    fill_in 'user_password_confirmation', :with => 'password'
    click_button 'Sign up'

    assert_equal user_displayqr_path, current_path

    click_button 'Continue...'

    assert_equal root_path, current_path
  end

  test 'a new user should be able to sign in without using their token' do
    create_full_user

    visit new_user_session_path
    fill_in 'user_email', :with => 'fulluser@test.com'
    fill_in 'user_password', :with => '123456'
    click_button 'Sign in'

    assert_equal root_path, current_path
  end

  test 'a new user should be able to sign in and change their qr code to enabled' do
    sign_in_as_user

    visit user_displayqr_path

    check 'user_gauth_enabled'
    click_button 'Continue...'

    assert_equal root_path, current_path
  end

  test 'a new user should be able to sign in change their qr to enabled and be prompted for their token' do
    create_and_signin_gauth_user

    assert_equal user_checkga_path, current_path
  end

  test 'fail token authentication' do
    create_and_signin_gauth_user
    fill_in 'user_token', :with => '1'
    click_button 'Check Token'

    assert_equal new_user_session_path, current_path
  end

  test 'successfull token authentication' do
    testuser = create_and_signin_gauth_user
    fill_in 'user_token', :with => ROTP::TOTP.new(testuser.get_qr).at(Time.now)
    click_button 'Check Token'

    assert_equal root_path, current_path
  end

  test 'unsuccessful login - if ga_timeout is short' do
    old_ga_timeout = User.ga_timeout
    User.ga_timeout = 1.second

    testuser = create_and_signin_gauth_user

    sleep(5)

    fill_in 'user_token', :with => ROTP::TOTP.new(testuser.get_qr).at(Time.now)
    click_button 'Check Token'

    User.ga_timeout = old_ga_timeout

    assert_equal new_user_session_path, current_path
  end

  test 'unsuccessful login - if ga_timedrift is short' do
    old_ga_timedrift = User.ga_timedrift
    User.ga_timedrift = 1

    testuser = create_and_signin_gauth_user
    fill_in 'user_token', :with => ROTP::TOTP.new(testuser.get_qr).at(Time.now.in(60))
    click_button 'Check Token'

    User.ga_timedrift = old_ga_timedrift

    assert_equal new_user_session_path, current_path
  end

  test 'user is not prompted for token again after first login until remembertime is up' do
    testuser = create_and_signin_gauth_user
    fill_in 'user_token', :with => ROTP::TOTP.new(testuser.get_qr).at(Time.now)
    click_button 'Check Token'

    assert_equal root_path, current_path

    visit destroy_user_session_path
    sign_in_as_user(testuser)
    assert_equal root_path, current_path
    visit destroy_user_session_path

    Timecop.travel(1.month.to_i + 1.day.to_i)
    sign_in_as_user(testuser)
    assert_equal user_checkga_path, current_path

    Timecop.return
  end
end