class AddEmailConfirmColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email_confirmed, :boolean, :default => false
    add_column :users, :confirm_token, :string
  end

  def self.down
    remove_column :users, :confirm_token
    remove_column :users, :email_confirmed
  end
end
