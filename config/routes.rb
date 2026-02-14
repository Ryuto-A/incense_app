Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get 'home/index'
  # ヘルスチェック用ルート
  get "up" => "rails/health#show", as: :rails_health_check

  # トップページを home#index に設定
  root "home#index"

  resources :incense_reviews do
    resources :comments, only: [:create, :destroy, :edit, :update]
    # お気に入り：作成はネスト、削除は shallow で /favorites/:id に DELETE
    resources :favorites, only: [:create, :destroy], shallow: true
  end

  # 開発上でメールをブラウザ表示
  if Rails.env.development? # rubocop:disable Style/IfUnlessModifier
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # 利用規約,プライバシーポリシーのページ設定
  get '/terms',   to: 'pages#terms',   as: :terms
  get '/privacy', to: 'pages#privacy', as: :privacy
end
