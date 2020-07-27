class CreateNotices < ActiveRecord::Migration
  def self.up
    create_table :notices do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.boolean :public, :default => false
      t.string :public_token

      t.timestamps
    end
  end

  def self.down
    drop_table :notices
  end
end
