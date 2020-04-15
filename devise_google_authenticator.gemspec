$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name = "devise_google_authenticator"
  s.version = "0.3.16"
  s.authors = ["Christian Frichot"]
  s.date = "2015-02-08"
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

  s.required_ruby_version = '>= 1.9.2'
  # s.required_rubygems_version = '>= 2.1.0'

  {
    # 'railties' => '~> 3.0',
    # removed the following to try and get past this bundle update not finding compatible versions for gem issue
    # 'actionmailer' => '>= 3.0', 
    #'actionmailer' => '~> 3.2',# '>= 3.2.12',
    'devise' => '>= 3.2',
    'rotp'   => '~> 1.6'
  }.each do |lib, version|
    s.add_runtime_dependency(lib, *version)
  end

end
