module DeviseGoogleAuthenticator
  module Controllers # :nodoc:
    module Helpers # :nodoc:
      def google_authenticator_qrcode(user, qualifier=nil, issuer=nil)
        issuer = user.class.ga_appname
        issuer = "#{issuer} (#{Rails.env})" unless Rails.env.production?
        issuer = Rack::Utils.escape(issuer)
        data = "otpauth://totp/#{user.first_authentication_key}?secret=#{user.gauth_secret}&issuer=#{issuer}"
        data = Rack::Utils.escape(data)
        url = "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=#{data}"
        return image_tag(url, :alt => 'Google Authenticator QRCode')
      end
    end
  end
end
