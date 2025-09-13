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

# CI環境用のドライバ分岐
if ENV["CI"]
  Capybara.register_driver :selenium_headless_ci do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless=new")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--window-size=1400,1400")
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  RSpec.configure do |config|
    config.before(:each, type: :system, js: true) do
      driven_by :selenium_headless_ci
    end
  end
end
