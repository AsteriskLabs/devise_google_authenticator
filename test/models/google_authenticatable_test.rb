require 'test_helper'
require 'model_tests_helper'

class GoogleAuthenticatableTest < ActiveSupport::TestCase
	test 'new users have a non-nil secret set' do
		assert_not_nil new_user.gauth_secret
	end

	test 'new users should have gauth_enabled disabled by default' do
		assert_equal 0, new_user.gauth_enabled.to_i
	end

	test 'get_qr method works' do
		assert_not_nil new_user.get_qr
	end

	test 'updating gauth_enabled to true' do
    user = new_user
		user.set_gauth_enabled(1)
		assert_equal 1, user.gauth_enabled.to_i
	end

	test 'updating gauth_enabled back to false' do
    user = new_user
		user.set_gauth_enabled(0)
		assert_equal 0, user.gauth_enabled.to_i
	end

	test 'updating the gauth_tmp key' do
    user = new_user
		user.assign_tmp
		
		assert_not_nil user.gauth_tmp
		assert_not_nil user.gauth_tmp_datetime
		
		sleep(1)
		
		old_tmp = user.gauth_tmp
		old_dt = user.gauth_tmp_datetime
		
		user.assign_tmp

		assert_not_equal old_tmp, user.gauth_tmp
		assert_not_equal old_dt, user.gauth_tmp_datetime
	end

	test 'testing token validation' do
    user = new_user
		assert !user.validate_token('1')
		assert !user.validate_token(ROTP::TOTP.new(user.get_qr).at(Time.now))

		user.assign_tmp

		assert !user.validate_token('1')
		assert user.validate_token(ROTP::TOTP.new(user.get_qr).at(Time.now))
	end

	test 'requiring token after remembertime' do
		u = new_user
		assert u.require_token?(nil)
		assert u.require_token?(u.email + "," + 2.months.ago.to_i.to_s)
		assert !u.require_token?(u.email + "," + 1.day.ago.to_i.to_s)
		assert u.require_token?("testxx@test.com" + "," + 1.day.ago.to_i.to_s)
	end

end
