require 'test_helper'

class ModelsTest < ActiveSupport::TestCase
  def include_module?(klass, mod)
    klass.devise_modules.include?(mod) &&
    klass.included_modules.include?(Devise::Models::const_get(mod.to_s.classify))
  end

  def assert_include_modules(klass, *modules)
    modules.each do |mod|
      assert include_module?(klass, mod), "#{klass} not include #{mod}"
    end

    (Devise::ALL - modules).each do |mod|
      assert !include_module?(klass, mod), "#{klass} include #{mod}"
    end
  end

  test 'should include Devise modules' do
    assert_include_modules User, :database_authenticatable, :registerable, :validatable, :rememberable, :trackable, :google_authenticatable, :recoverable
  end

  test 'should have a default value for ga_timeout' do
    assert_equal 3.minutes, User.ga_timeout
  end

  test 'should have a default value for ga_timedrift' do
    assert_equal 3, User.ga_timedrift
  end

  test 'should have a new value for ga_appname' do
    old_ga_appname = User.ga_appname
    User.ga_appname = "test.app"

    assert_equal "test.app", User.ga_appname

    User.ga_appname = old_ga_appname
  end

  test 'should set a new value for ga_timeout' do
    old_ga_timeout = User.ga_timeout
    User.ga_timeout = 1.minutes

    assert_equal 1.minutes, User.ga_timeout

    User.ga_timeout = old_ga_timeout
  end

  test 'should set a new value for ga_timedrift' do
    old_ga_timedrift = User.ga_timedrift
    User.ga_timedrift = 2

    assert_equal 2, User.ga_timedrift

    User.ga_timedrift = old_ga_timedrift
  end

  test 'should have a default value for ga_skip_validation_if' do
    assert_equal false, User.ga_skip_validation_if
    assert_equal false, User.first.skip_validation?(nil)
  end

  test 'should set a new value for ga_skip_validation_if' do
    old_ga_skip_validation_if = User.ga_skip_validation_if
    User.ga_skip_validation_if = ->(user, _) { user.email == 'fulluser@test.com' }

    assert_equal true, User.first.skip_validation?(nil)

    User.ga_skip_validation_if = old_ga_skip_validation_if
  end

  test 'google_authenticatable attributes' do
    assert_equal 'f', User.new.gauth_enabled
    assert_nil User.new.gauth_tmp
    assert_nil User.new.gauth_tmp_datetime
  end
end
