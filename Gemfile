source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
gem "activesupport", "3.1.3"
gem "rails"
gem "devise"
gem "rotp"

gemspec

# The below are yoinked from devise_invitable's gemfile
group :test do
  gem "sqlite3"
  gem "mongoid", "~> 2.0"
  gem "bson_ext", "~> 1.3"
  gem "capybara", "~> 0.4.0"
  gem 'shoulda', '~> 2.11.3'
  gem 'mocha', '~> 0.9.9'
  gem 'factory_girl_rails', '~> 1.0'
  gem 'rspec-rails', '~> 2.5.0'
end

# End devise_invitable's gemfile stuff

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "shoulda", "~> 2.11.3"
  gem "bundler", "~> 1.0.0"
  gem "jeweler", "~> 1.6.4"
  gem "simplecov"
end
