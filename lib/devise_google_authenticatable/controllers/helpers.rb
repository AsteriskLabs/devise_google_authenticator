require 'rqrcode'
require 'base64'

module DeviseGoogleAuthenticator #:nodoc:
  module Controllers # :nodoc:
    module Helpers # :nodoc:
      def google_authenticator_qrcode(user, qualifier = nil, issuer = nil)
        username = nil
        Devise.authentication_keys.any? {|k| username = user.public_send(k) rescue nil }
        username ||= username_from_email(user.email)
        app = user.class.ga_appname || Rails.application.class.parent_name
        data = "otpauth://totp/#{otpauth_user(username, app, qualifier)}?secret=#{user.gauth_secret}"
        data << "&issuer=#{issuer}" if !issuer.nil?
        # data-uri is easier, so...
        qrcode = RQRCode::QRCode.new(data, level: :m, mode: :byte_8bit)
        png = qrcode.as_png(fill: 'white', color: 'black', border_modules: 1, module_px_size: 4)
        url = "data:image/png;base64,#{Base64.encode64(png.to_s).strip}"
        #url = "data:image/svg+xml;utf8,#{qrcode.as_svg}"
        #url = "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=#{Rack::Utils.escape(data)}"
        return image_tag(url, alt: 'Google Authenticator QRCode')
      end

      def otpauth_user(username, app, qualifier = nil)
        "#{username}@#{app}#{qualifier}"
      end

      def username_from_email(email)
        ((/^(.*)@/).match(email) || [])[1]
      end
    end
  end
end
