require 'test_helper'
require 'devise_google_authenticatable/patches/check_ga'

class MockCheckGA
  def create; end

  include DeviseGoogleAuthenticator::Patches::CheckGA
end

module Nested
  class Admin # rubocop:todo Lint/EmptyClass
  end
end

class User # rubocop:todo Lint/EmptyClass
end

class CheckGaTest < ActiveSupport::TestCase
  test 'handles namespaces' do
    assert_equal "admin_checkga_path(id:'1')", MockCheckGA.new.checkga_resource_path_name(Nested::Admin.new, 1)
  end
  test 'handles non-namespaced paths' do
    assert_equal "user_checkga_path(id:'1')", MockCheckGA.new.checkga_resource_path_name(User.new, 1)
  end
end
