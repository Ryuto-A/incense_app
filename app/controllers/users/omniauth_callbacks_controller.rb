# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # プロバイダの「表示名」ではなく「キー」を渡す.
  def google_oauth2 = handle_auth("google_oauth2")
  def github        = handle_auth("github")
  def line          = handle_auth("line")

  def failure
    redirect_to(
      new_user_session_path,
      alert: t("devise.omniauth_callbacks.failure", kind: failed_strategy_kind, reason: failure_message)
    )
  end

  private

  # コールバック共通処理。詳細ロジックは User.from_omniauth に委譲して薄く保つ
  def handle_auth(provider_key)
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth, current_user)

    if @user.persisted?
      if current_user
        # 既ログイン中 → SNS アカウントの紐づけ完了
        redirect_to after_link_path, notice: t("devise.omniauth_callbacks.success", kind: human_kind(provider_key))
      else
        # 新規/既存ユーザへのサインイン
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: human_kind(provider_key)) if is_navigational_format?
      end
    else
      # 登録フォームへ。Devise の慣例キーでセッションに保存（extra は除外）
      session["devise.#{provider_key}_data"] = auth.except(:extra)
      redirect_to(
        new_user_registration_url,
        alert: t("devise.omniauth_callbacks.failure", kind: human_kind(provider_key), reason: "アカウント作成に失敗しました")
      )
    end
  end

  # 表示用のラベル。必要に応じて i18n 化しても良い
  def human_kind(provider_key)
    case provider_key.to_s
    when "google_oauth2" then "Google"
    when "github"        then "GitHub"
    when "line"          then "LINE"
    else provider_key.to_s.titleize
    end
  end

  def failed_strategy_kind
    (env["omniauth.error.strategy"]&.name || "SNS").to_s.titleize
  end

  def failure_message
    env["omniauth.error.type"].to_s.humanize.presence || "Unknown error"
  end

  # 紐づけ後の戻り先（プロフィールやトップなど任意）
  def after_link_path
    stored_location_for(:user) || root_path
  end
end
