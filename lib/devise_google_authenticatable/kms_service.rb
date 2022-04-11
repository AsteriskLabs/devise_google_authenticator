# frozen_string_literal: true

require 'google/cloud/kms'

module DeviseGoogleAuthenticator
  class KmsService
    def initialize(kms_key_name)
      @kms_key_name = kms_key_name
    end

    def decrypt(ciphertext)
      client = Google::Cloud::Kms.new
      response = client.decrypt(kms_key_name, ciphertext)
      response.plaintext
    end

    def encrypt(plaintext)
      client = Google::Cloud::Kms.new
      response = client.encrypt(kms_key_name, plaintext)
      response.ciphertext
    end

    private

    attr_reader :kms_key_name
  end
end
