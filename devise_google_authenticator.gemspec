$LOAD_PATH.unshift File.expand_path('lib', __dir__)

Gem::Specification.new do |s|
  s.name = "devise_google_authenticator"
  s.version = "0.4.0"
  s.authors = ["Christian Frichot", "Matthew Tanous"]
  s.description = "Devise Google Authenticator Extension, for adding Google's OTP to your Rails apps!"
  s.email = "matt.tanous@redcanary.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = Dir["{app,config,lib}/**/*"] + %w[LICENSE.txt README.rdoc]
  s.homepage = "http://github.com/AsteriskLabs/devise_google_authenticator"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.summary = "Devise Google Authenticator Extension"

  s.required_ruby_version = '>= 2.3.3' # rubocop:todo Gemspec/RequiredRubyVersion
  # s.required_rubygems_version = '>= 2.1.0'

  s.add_runtime_dependency 'devise', '~> 4.6'
  s.add_runtime_dependency 'rotp', '~> 5.0'
end
