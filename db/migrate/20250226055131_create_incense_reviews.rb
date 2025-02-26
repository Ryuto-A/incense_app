class CreateIncenseReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :incense_reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :scent_category, null: false
      t.integer :smoke_intensity, null: false
      t.text :content, null: false
      t.string :product_url
      t.string :product_name
      t.string :product_image

      t.timestamps
    end
  end
end
