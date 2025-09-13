# frozen_string_literal: true

Devise.setup do |config|
  # Mailer
  config.mailer_sender = 'no-reply@example.com'

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
end
