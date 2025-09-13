FactoryBot.define do
    factory :incense_review do
      association :user
      title { "Sample Review" }
      content { "本文テキスト" }
      scent_category { :sweet }      # enum
      smoke_intensity { 3 }
      product_name { "Sample Product" }
    end
  end
  