Rails.application.routes.draw do
  get 'home/index'
  # ヘルスチェック用ルート
  get "up" => "rails/health#show", as: :rails_health_check

  # トップページを home#index に設定
  root "home#index"
end
