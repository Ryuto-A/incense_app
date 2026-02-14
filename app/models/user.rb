class User < ApplicationRecord
  has_many :incense_reviews, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :authentications, dependent: :destroy, inverse_of: :user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 github line]

  # 所有者を判定する
  def own?(object)
    self.id == object.user_id
    id == object.user_id
  end

  # OmniAuth からユーザーを解決/紐づけ
  # current_user がいる場合は既存ユーザーにSNSアカウントをリンクする
  def self.from_omniauth(auth, current_user = nil)
    provider = auth.provider
    uid      = auth.uid
    info     = auth.info || OpenStruct.new

    # すでに紐づけ済みなら即返す
    if (identity = Authentication.find_by(provider:, uid:))
      return identity.user
    end

    # 既ログイン中なら現在ユーザーにリンクして返す
    return link_current_user!(current_user, provider, uid) if current_user

    # 未ログイン：メールで既存検索 or 作成 → 紐づけ
    user = find_user_by_info(info) || create_user_from_info!(info, provider, uid)
    user.authentications.create!(provider:, uid:)
    user
  end

  # ---- 以下ヘルパ（複雑度を分散）----
  def self.link_current_user!(current_user, provider, uid)
   current_user.authentications.create!(provider:, uid:)
   current_user
  end

  private_class_method :link_current_user!

  def self.find_user_by_info(info)
    email = info.email.presence
    email && User.find_by(email:)
  end
  private_class_method :find_user_by_info

  def self.create_user_from_info!(info, provider, uid)
    User.create!(
      email: info.email.presence || dummy_email(provider, uid),
      password: SecureRandom.hex(16),
      name: info.name.presence || info.nickname.presence || "SNSユーザー"
    )
  end

  private_class_method :create_user_from_info!

  def self.dummy_email(provider, uid)
    "tmp-#{provider}-#{uid}@example.invalid"
  end
  private_class_method :dummy_email
end
