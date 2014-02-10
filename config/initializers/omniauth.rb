Rails.application.config.middleware.use OmniAuth::Builder do
  provider :fitbit, 'b4aacb5c2c8c43e2a6873877cd2ad9b1', '88bd78fc86d84d6c9aa7b1c0b8d4511f'
end