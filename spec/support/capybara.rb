# Capybaraの基本設定
Capybara.default_max_wait_time = 3

RSpec.configure do |config|
  # デフォルトは rack_test（JSなし・高速）
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  # JSテストは Selenium + Headless Chrome
  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end
end
