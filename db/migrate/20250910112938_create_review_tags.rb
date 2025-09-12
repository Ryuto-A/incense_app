class CreateReviewTags < ActiveRecord::Migration[7.1]
  def change
    create_table :review_tags do |t|
      t.bigint :review_id, null: false
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end

    add_index :review_tags, :review_id
    add_index :review_tags, [:review_id, :tag_id], unique: true
    add_foreign_key :review_tags, :incense_reviews, column: :review_id
  end
end
