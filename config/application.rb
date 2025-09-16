require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module IncenseApp
  class Application < Rails::Application
    config.load_defaults 7.1

    # lib 配下の autoload（assets / tasks は除外）
    config.autoload_lib(ignore: %w[assets tasks])

    # 画像処理はActive Storageを全環境でVipsに統一して設定
    config.active_storage.variant_processor = :vips

    # 日本語化用 internationalization I18n（日本語を既定・英語フォールバック・サブディレクトリも読み込み）
    config.i18n.default_locale = :ja
    config.i18n.available_locales = %i[ja en]
    config.i18n.fallbacks        = [:en]
    config.i18n.load_path       += Dir[Rails.root.join("config/locales/**/*.{rb,yml,yaml}")]

    # アプリのタイムゾーン（DBはUTCのままが一般的。必要なら下行を有効化）
    config.time_zone = "Tokyo"
    # config.active_record.default_timezone = :local
  end
end
