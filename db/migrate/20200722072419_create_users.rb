class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :email_confirmed, :default => false
      t.string :confirm_token
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
