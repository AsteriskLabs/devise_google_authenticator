# Helpers for creating new users
class ActiveSupport::TestCase
  def generate_unique_email #:nodoc:
    @@email_count ||= 0
    @@email_count += 1
    "test#{@@email_count}@example.com"
  end

  def valid_attributes(attributes = {}) #:nodoc:
    {
      email: generate_unique_email,
      password: '123456',
      password_confirmation: '123456'
    }.merge(attributes)
  end

  def new_user(attributes = {}) #:nodoc:
    user = User.new(valid_attributes(attributes))
    user.save!
    user
  end
end
