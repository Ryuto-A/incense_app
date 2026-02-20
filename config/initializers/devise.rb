# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Devise.setup do |config|
  # Mailer: メールフォーム。後で本番はENVに寄せるのでデフォルトを置いておく
  config.mailer_sender = ENV.fetch("DEFAULT_FROM_EMAIL", "no-reply@incense-app.example")
  # フィッシング耐性を少し上げるなら（存在しないメールでも同じレスにする）
  config.paranoid = true

  # ORM
  require 'devise/orm/active_record'

  # Authentication keys
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # Session handling
  config.skip_session_storage = [:http_auth]
  config.sign_out_via = :delete

  # Password hashing / validations
  config.stretches = Rails.env.test? ? 1 : 12
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours

  # Confirmable
  config.reconfirmable = true

  # Rememberable
  config.expire_all_remember_me_on_sign_out = true

  # Hotwire / Turbo (recommended when using Turbo)
  config.navigational_formats = ['*/*', :html, :turbo_stream]
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  # OmniAuth providers
  OmniAuth.config.allowed_request_methods = %i[post] # 安全策（omniauth-rails_csrf_protection 併用）
  # CI/test は dummyで起動

  omniauth_key = ->(name) do
    Rails.env.test? ? "dummy" : ENV.fetch(name)
  end

  config.omniauth :github,
                  omniauth_key.call("GITHUB_CLIENT_ID"),
                  omniauth_key.call("GITHUB_CLIENT_SECRET"),
                  scope: "user:email"

  config.omniauth :google_oauth2,
                  omniauth_key.call("GOOGLE_CLIENT_ID"),
                  omniauth_key.call("GOOGLE_CLIENT_SECRET"),
                  scope: "email,profile"

  config.omniauth :line,
                  omniauth_key.call("LINE_CHANNEL_ID"),
                  omniauth_key.call("LINE_CHANNEL_SECRET"),
                  scope: "openid profile email",
                  prompt: "consent"
end
# rubocop:enable Metrics/BlockLength
