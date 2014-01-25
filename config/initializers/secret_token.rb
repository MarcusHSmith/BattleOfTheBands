# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
BattleOfTheBands::Application.config.secret_token = 'a51c926cfe9c318c6efbb19cafc3ea88d508cb641d9eb84afee45e07a3c1397ffb9afd388e16994b4e46176a4ad0b0f9c38819291fe124a89fd53235006a9374'

require 'securerandom'

def secure_token
  token_file = Rails.root.join('.secret')
  if File.exist?(token_file)
    # Use the existing token.
    File.read(token_file).chomp
  else
    # Generate a new token and store it in token_file.
    token = SecureRandom.hex(64)
    File.write(token_file, token)
    token
  end
end

BattleOfTheBands::Application.config.secret_key_base = secure_token