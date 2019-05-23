# frozen_string_literal: true

require 'base64'
require_relative 'secure_message'

## Token and Detokenize Authorization Information
# Usage examples:
#  token = AuthToken.create({ key: 'value', key2: 12 }, AuthToken::ONE_MONTH)
#  AuthToken.payload(token)   # => {"key"=>"value", "key2"=>12}
class RegistrationToken
  ONE_MINUTE = 60
  THREE_MINUTES = ONE_MINUTE * 3
  ONE_HOUR = ONE_MINUTE * 60
  ONE_DAY = ONE_HOUR * 24
  ONE_WEEK = ONE_DAY * 7
  ONE_MONTH = ONE_WEEK * 4
  ONE_YEAR = ONE_MONTH * 12

  class ExpiredTokenError < StandardError; end
  class InvalidTokenError < StandardError; end

  # Create a token from a Hash payload
  def self.create(payload, expiration = ONE_MINUTE)
    contents = { 'payload' => payload, 'exp' => expires(expiration) }
    tokenize(contents)
  end

  # Extract data from token
  def self.payload(token)
    contents = detokenize(token)
    expired?(contents) ? raise(ExpiredTokenError) : contents['payload']
  end

  # Tokenize contents or return nil if no data
  def self.tokenize(message)
    return nil unless message

    SecureMessage.encrypt(message)
  end

  # Detokenize and return contents, or raise error
  def self.detokenize(ciphertext64)
    return nil unless ciphertext64

    SecureMessage.decrypt(ciphertext64)
  rescue StandardError
    raise InvalidTokenError
  end

  def self.expires(expiration)
    (Time.now + expiration).to_i
  end

  def self.expired?(contents)
    puts 'time warranty: ' + Time.at(contents['exp']).ctime 
    puts 'time now ' + Time.now.ctime
    Time.now > Time.at(contents['exp'])
  rescue StandardError
    raise InvalidTokenError
  end
end
