class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :notes, id: :uuid do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.references :user, null: false, type: :bigint, foreign_key: true
      t.boolean :public, default: false, null: false
      t.string :public_token
      t.string :slug

      t.timestamps null: false
    end

    add_index :notes, :public_token, unique: true
    add_index :notes, :slug, unique: true
  end
end
