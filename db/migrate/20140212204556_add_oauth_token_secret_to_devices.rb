class AddOauthTokenSecretToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :oauth_token_secret, :string
  end
end
