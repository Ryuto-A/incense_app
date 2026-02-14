# frozen_string_literal: true

class CreateAuthentications < ActiveRecord::Migration[7.1]
  def change
    create_table :authentications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid,      null: false

      t.timestamps
    end

    add_index :authentications, [:provider, :uid], unique: true
    add_index :authentications, :provider
    add_index :authentications, :uid
  end
end
