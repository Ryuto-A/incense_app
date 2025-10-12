class CreateFavorites < ActiveRecord::Migration[7.1]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :review_id, null: false

      t.timestamps
    end

    add_foreign_key :favorites, :incense_reviews, column: :review_id
    add_index :favorites, %i[user_id review_id], unique: true
    add_index :favorites, :review_id
  end
end
