require 'test_helper'
require 'devise_google_authenticatable/controllers/helpers'

class HelpersTest < ActiveSupport::TestCase
    include DeviseGoogleAuthenticator::Controllers::Helpers

    def setup
	    @user = User.new(valid_attributes({:email => 'helpers_test@test.com' }))
        User.ga_appname = 'Simple App'
	end

    # fake image tag
    def image_tag(src, *args)
        src
    end
    test 'generate qrcode' do
        assert_equal "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth%3A%2F%2Ftotp%2Fhelpers_test%40test.com%3Fsecret%3D%26issuer%3DSimple%2BApp%2B%2528test%2529", google_authenticator_qrcode(@user)
        assert_equal "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth%3A%2F%2Ftotp%2Fhelpers_test%40test.com%3Fsecret%3D%26issuer%3DSimple%2BApp%2B%2528test%2529", google_authenticator_qrcode(@user, 'MyQualifier')
        assert_equal "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth%3A%2F%2Ftotp%2Fhelpers_test%40test.com%3Fsecret%3D%26issuer%3DSimple%2BApp%2B%2528test%2529", google_authenticator_qrcode(@user, nil, 'MyIssuer')
        assert_equal "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth%3A%2F%2Ftotp%2Fhelpers_test%40test.com%3Fsecret%3D%26issuer%3DSimple%2BApp%2B%2528test%2529", google_authenticator_qrcode(@user, 'MyQualifier', 'MyIssuer')
    end
end
