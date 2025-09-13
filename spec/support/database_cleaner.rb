RSpec.configure do |config|
    # JSなしはトランザクションでOK
    # JSあり(:system, js:true)は別スレッドで動くため truncation に切替
    config.before(:suite) do
      DatabaseCleaner.allow_remote_database_url = true
      DatabaseCleaner.clean_with(:truncation)
    end
  
    config.before(:each) do
      DatabaseCleaner.strategy = :transaction
    end
  
    config.before(:each, type: :system, js: true) do
      DatabaseCleaner.strategy = :truncation
    end
  
    config.before(:each) { DatabaseCleaner.start }
    config.append_after(:each) { DatabaseCleaner.clean }
  end
  