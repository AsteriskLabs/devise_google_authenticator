require 'test_helper'
require 'devise_google_authenticatable/controllers/helpers'

class HelpersTest < ActiveSupport::TestCase
  include DeviseGoogleAuthenticator::Controllers::Helpers

  def setup
    @user = User.new(valid_attributes({:email => 'helpers_test@test.com' }))
  end

  test "can get username from user's email" do
    assert_equal 'helpers_test', username_from_email(@user.email)
  end

  test 'can get otpauth_user' do
    assert_equal "username@app", otpauth_user('username', 'app')
  end

  test 'can get otpauth_user with a qualifier' do
    assert_equal "username@app-qualifier", otpauth_user('username', 'app', '-qualifier')
  end

  # fake image tag
  def image_tag(src, *args)
    src
  end
  test 'generate qrcode' do
    assert_equal 'data:image/png;base64,', google_authenticator_qrcode(@user).first(22)
  end
end
