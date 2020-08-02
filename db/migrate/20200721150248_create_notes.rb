class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.boolean :public, :default => false
      t.string :public_token

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
