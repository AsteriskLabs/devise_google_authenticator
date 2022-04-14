# frozen_string_literal: true

require 'google/cloud/kms'

module DeviseGoogleAuthenticator
  class KmsService
    def initialize(credentials, kms_key_name)
      @credentials = credentials
      @kms_key_name = kms_key_name
    end

    def decrypt(ciphertext)
      client = Google::Cloud::Kms.new(credentials: credentials)
      response = client.decrypt(kms_key_name, ciphertext)
      response.plaintext
    end

    def encrypt(plaintext)
      client = Google::Cloud::Kms.new(credentials: credentials)
      response = client.encrypt(kms_key_name, plaintext)
      response.ciphertext
    end

    private

    attr_reader :credentials, :kms_key_name
  end
end
