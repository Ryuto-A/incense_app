class AddFavoritesCountToIncenseReviews < ActiveRecord::Migration[7.1]
  def change
    add_column :incense_reviews, :favorites_count, :integer, null: false, default: 0
  end
end
