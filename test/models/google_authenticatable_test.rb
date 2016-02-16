require 'test_helper'
require 'model_tests_helper'

class GoogleAuthenticatableTest < ActiveSupport::TestCase
  def setup
    @u = new_user
  end

  test 'new users have a non-nil secret set' do
    assert_not_nil @u.gauth_secret
  end

  test 'new users should have gauth_enabled disabled by default' do
    assert_equal 0, @u.gauth_enabled.to_i, "Google auth: #{@u.gauth_enabled.inspect}"
  end

  test 'get_qr method works' do
    assert_not_nil @u.get_qr
  end

  test 'updating gauth_enabled to true' do
    @u.set_gauth_enabled(1)
    assert_equal 1, @u.gauth_enabled.to_i
  end

  test 'updating gauth_enabled back to false' do
    @u.set_gauth_enabled(0)
    assert_equal 0, @u.gauth_enabled.to_i
  end

  test 'updating the gauth_tmp key' do
    @u.assign_tmp

    assert_not_nil @u.gauth_tmp
    assert_not_nil @u.gauth_tmp_datetime

    sleep(1)

    old_tmp = @u.gauth_tmp.dup
    old_dt = @u.gauth_tmp_datetime.dup

    @u.assign_tmp

    assert_not_equal old_tmp, @u.gauth_tmp
    assert_not_equal old_dt, @u.gauth_tmp_datetime
  end

  test 'class method for finding by tmp key' do
    assert User.find_by_gauth_tmp('invalid').nil?, 'Found user by token "invalid"'
    assert !User.find_by_gauth_tmp(@u.gauth_tmp).nil?, 'Unable to find user'
  end

  test 'token validation' do
    assert !@u.validate_token('1')
    assert !@u.validate_token(ROTP::TOTP.new(@u.get_qr).at(Time.now))

    @u.assign_tmp

    assert !@u.validate_token('1')
    assert @u.validate_token(ROTP::TOTP.new(@u.get_qr).at(Time.now))
  end

  test 'requiring token after remembertime' do
    assert @u.require_token?(nil)
    assert @u.require_token?(@u.email + ',' + 2.months.ago.to_i.to_s)
    assert !@u.require_token?(@u.email + ',' + 1.day.ago.to_i.to_s)
    assert @u.require_token?('some_other_email@example.com' + ',' + 1.day.ago.to_i.to_s)
  end
end
