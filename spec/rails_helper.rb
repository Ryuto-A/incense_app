# spec/rails_helper.rb
# This file is copied to spec/ when you run 'rails generate rspec:install'

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"

# 1) Rails本体を先に読み込む
require_relative "../config/environment"
abort("The Rails environment is running in production mode!") if Rails.env.production?

# 2) RSpec/Rails/Capybara を読み込む
require "rspec/rails"
require "capybara/rspec"

# 3) support配下は “Rails読み込み後” に require する（重要）
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

# 4) DBスキーマを最新に
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # fixtures のパス（必要なら利用）
  config.fixture_paths = [Rails.root.join("spec/fixtures")]

  # トランザクション（JSありは support/database_cleaner.rb 側で切替）
  config.use_transactional_fixtures = true

  # FactoryBot のショートハンド
  config.include FactoryBot::Syntax::Methods

  # specの場所から type を推論（model/systemなど）
  config.infer_spec_type_from_file_location!

  # バックトレースのノイズを減らす
  config.filter_rails_from_backtrace!
end
