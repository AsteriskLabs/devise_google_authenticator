# frozen_string_literal: true

require 'google/cloud/kms'

module DeviseGoogleAuthenticator
  class KmsService
    def initialize(kms_key_name)
      @kms_key_name = kms_key_name
    end

    def decrypt(ciphertext)
      client = Google::Cloud::Kms.key_management_service
      response = client.decrypt(name: kms_key_name, ciphertext: ciphertext)
      response.plaintext
    end

    def encrypt(plaintext)
      client = Google::Cloud::Kms.key_management_service
      response = client.encrypt(name: kms_key_name, plaintext: plaintext)
      response.ciphertext
    end

    private

    attr_reader :kms_key_name
  end
end
