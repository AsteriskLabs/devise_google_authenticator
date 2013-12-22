# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name = "devise_google_authenticator"
  s.version = "0.3.7"
  s.authors = ["Christian Frichot"]
  s.date = "2013-08-13"
  s.description = "Devise Google Authenticator Extension, for adding Google's OTP to your Rails apps!"
  s.email = "xntrik@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = Dir["{app,config,lib}/**/*"] + %w[LICENSE.txt README.rdoc]
  s.homepage = "http://github.com/AsteriskLabs/devise_google_authenticator"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.summary = "Devise Google Authenticator Extension"

  s.required_ruby_version = '>= 1.8.6'
  s.required_rubygems_version = '>= 1.3.6'

  s.add_development_dependency('bundler', '~> 1.3.0')

  {
    'railties' => '>= 3.0',
    'actionmailer' => '>= 3.0',
    'devise' => '>= 2.2.0',
    'rotp'   => '~> 1.4.0'
  }.each do |lib, version|
    s.add_runtime_dependency(lib, *version)
  end

end