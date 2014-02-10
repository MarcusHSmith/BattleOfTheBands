class AddOauthToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :oauth_token, :string
    add_column :devices, :oauth_verifier, :string
  end
end
