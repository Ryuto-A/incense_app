Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get 'home/index'
  # ヘルスチェック用ルート
  get "up" => "rails/health#show", as: :rails_health_check

  # トップページを home#index に設定
  root "home#index"

  resources :incense_reviews

end
