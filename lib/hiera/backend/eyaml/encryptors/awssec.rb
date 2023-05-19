require 'hiera/backend/eyaml/encryptor'
require 'hiera/backend/eyaml/options'
require 'aws-sdk-secretsmanager'
require 'json'

class Hiera
  module Backend
    module Eyaml
      module Encryptors

        class AWSSec < Encryptor
          self.options = {
            :region => {
              :desc => "AWS Region",
              :type => :string,
              :default => 'us-east-1'
            },
            :cache_response => {
              :desc => "Cache response",
              :type => :boolean,
              :default => true
            }
          }

          @cache = {}

          VERSION = "0.1"
          self.tag = "AWSSEC"

          def self.encrypt plaintext
            raise StandardError, "Encryption is not supported with this encryptor."
          end

          def self.decrypt string
            secret_id, secret_key = string.split("/")
            result = @cache.has_key?(secret_id) ? @cache[secret_id] : self.fetch_value(secret_id)
            result = result[secret_key] unless secret_key.nil?
            result
          end

          def self.fetch_value (secret_id)
            resp = self.client.get_secret_value({
              secret_id: secret_id 
            })

            result = resp[:secret_string]

            begin
              result = JSON.parse(result)
            rescue => exception
            end

            @cache[secret_id] = result if self.option(:cache_response)
            result
          end

          def self.encode string
            string
          end

          def self.decode string
            string
          end

          def self.client
            region = self.option :region
            @client = ::Aws::SecretsManager::Client.new(region: region)
          end 

        end

      end

    end

  end

end
