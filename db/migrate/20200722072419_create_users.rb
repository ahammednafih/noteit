class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :user_name
      t.string :first_name
      t.string :last_name
      t.string :full_name
      t.string :email
      t.string :avatar
      t.string :password_digest
      t.boolean :email_confirmed, :default => false
      t.string :confirm_token
      t.datetime :last_login_at
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
