require 'test_helper'
require 'integration_tests_helper'

class InvitationTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpers
  self.use_transactional_fixtures = false

  def teardown
    Capybara.reset_sessions!
    Timecop.return
  end

  # test 'register new user - confirm that we get a display qr page after registering' do
  #   visit new_user_registration_path
  #   fill_in('user_email', :with => 'test@test.com')
  #   fill_in('user_password', :with => 'Password1')
  #   fill_in('user_password_confirmation', :with => 'Password1')
  #   click_link_or_button 'Sign up'

  #   assert_equal user_displayqr_path, current_path

  #   click_button 'Continue...'

  #   assert_equal root_path, current_path
  # end

  # test 'a new user should be able to sign in without using their token' do
  #   create_full_user

  #   visit new_user_session_path
  #   fill_in 'user_email', :with => 'fulluser@test.com'
  #   fill_in 'user_password', :with => '123456'
  #   click_button 'Sign in'

  #   assert_equal root_path, current_path
  # end

  # test 'a new user should be able to sign in and change their qr code to enabled' do
  #   # sign_in_as_user
  #   create_full_user
  #   visit new_user_session_path
  #   fill_in 'user_email', :with => 'fulluser@test.com'
  #   fill_in 'user_password', :with => '123456'
  #   click_button 'Sign in'

  #   visit user_displayqr_path

  #   check 'user_gauth_enabled'
  #   click_button 'Continue...'

  #   assert_equal root_path, current_path
  # end

  test 'a new user should be able to sign in change their qr to enabled and be prompted for their token' do
    puts "User" + User.all.to_s
    create_full_user
    puts "User" + User.all.to_s
    visit new_user_session_path
    puts "Page 1"
    puts
    puts page.body
    fill_in 'user_email', :with => 'fulluser@test.com'
    fill_in 'user_password', :with => '123456'
    click_button 'Log in'

    visit user_displayqr_path
    puts "Page 2"
    puts
    puts page.body
    check 'user_gauth_enabled'
    click_button 'Continue...'

    puts "User"+User.find(1).gauth_enabled
    tmp_user = User.find(1)
    tmp_user.gauth_enabled = 1
    tmp_user.save!
    puts "User:"
    puts User.find(1).gauth_enabled
    visit user_displayqr_path
    puts "Page 3"
    puts
    puts page.body
    Capybara.reset_sessions!

    visit new_user_session_path
    puts "Page 3"
    puts
    puts page.body
    fill_in 'user_email', :with => 'fulluser@test.com'
    fill_in 'user_password', :with => '123456'
    click_button 'Log in'

    assert_equal user_checkga_path, current_path
  end

  # test 'fail token authentication' do
  #   create_and_signin_gauth_user
  #   fill_in 'user_token', :with => '1'
  #   click_button 'Check Token'

  #   assert_equal new_user_session_path, current_path
  # end

  # test 'successfull token authentication' do
  #   testuser = create_and_signin_gauth_user
  #   fill_in 'user_token', :with => ROTP::TOTP.new(testuser.get_qr).at(Time.now)
  #   click_button 'Check Token'

  #   assert_equal root_path, current_path
  # end

  # test 'unsuccessful login - if ga_timeout is short' do
  #   old_ga_timeout = User.ga_timeout
  #   User.ga_timeout = 1.second

  #   testuser = create_and_signin_gauth_user

  #   sleep(5)

  #   fill_in 'user_token', :with => ROTP::TOTP.new(testuser.get_qr).at(Time.now)
  #   click_button 'Check Token'

  #   User.ga_timeout = old_ga_timeout

  #   assert_equal new_user_session_path, current_path
  # end

  # test 'unsuccessful login - if ga_timedrift is short' do
  #   old_ga_timedrift = User.ga_timedrift
  #   User.ga_timedrift = 1

  #   testuser = create_and_signin_gauth_user
  #   fill_in 'user_token', :with => ROTP::TOTP.new(testuser.get_qr).at(Time.now.in(60))
  #   click_button 'Check Token'

  #   User.ga_timedrift = old_ga_timedrift

  #   assert_equal new_user_session_path, current_path
  # end

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

  test 'skip validation will not prompt the checkga page' do
    default_value = User.ga_skip_validation_if

    $skip_validation = false
    User.ga_skip_validation_if = ->(user, request) { $skip_validation }

    testuser = User.create!(
      username: 'skip_validation_usertest',
      email: 'skip_validation@test.com',
      password: '123456',
      password_confirmation: '123456'
    )
    testuser.gauth_enabled = 1
    testuser.save!

    Capybara.reset_sessions!

    sign_in_as_user(testuser)
    assert_equal user_checkga_path, current_path

    $skip_validation = true

    Capybara.reset_sessions!

    sign_in_as_user(testuser)
    assert_equal root_path, current_path

    Capybara.reset_sessions!

    # Skip if from localhost

    User.ga_skip_validation_if = ->(user, request) { request.remote_ip == '127.0.0.1' }

    sign_in_as_user(testuser)
    assert_equal root_path, current_path

    Capybara.reset_sessions!

    # Skip if not from localhost

    User.ga_skip_validation_if = ->(user, request) { request.remote_ip != '127.0.0.1' }

    sign_in_as_user(testuser)
    assert_equal user_checkga_path, current_path

    User.ga_skip_validation_if = default_value
  end
end
