module DeviseGoogleAuthenticator
  module Controllers # :nodoc:
    module Helpers # :nodoc:
      def google_authenticator_qrcode(user, qualifier=nil, issuer=nil)
        issuer = user.class.ga_appname
        issuer = "#{issuer} (#{Rails.env})" unless Rails.env.production?
        data = "otpauth://totp/#{user.email}?secret=#{user.gauth_secret}&issuer=#{issuer}"
        data << "&issuer=#{issuer}" if !issuer.nil?
        data = Rack::Utils.escape(data)
        url = "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=#{data}"
        return image_tag(url, :alt => 'Google Authenticator QRCode')
      end
    end
  end
end
