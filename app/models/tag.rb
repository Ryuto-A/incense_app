class Tag < ApplicationRecord
    has_many :review_tags, dependent: :destroy
    has_many :incense_reviews, through: :review_tags, source: :incense_review
  
    before_validation :normalize_name
    validates :name, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
  
    private
    def normalize_name
      self.name = name.to_s.strip
    end
  end
