class AddEmailPasswordToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email, :string # rails-code
    add_column :users, :password_hash, :string # rails-code
    add_column :users, :password_salt, :string # rails-code

    add_column :users, :avatar_url, :string # my -code
  end
end
